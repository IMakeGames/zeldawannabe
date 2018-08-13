# Core Character Class
# All characters inherit from this object.
# Introduces new attributes.
# Class Attributes:
# * face_dir: The direction the character is facing
# * event_tiks: Counter that indicates the amount of event frames left for a certain event.
# * current_speed: The speed the character is moving at, if it's moving at all.
# * current_hp, total_hp: Self explanatory.
# * recoil_frames: Total number of frames designated to recoiling for this character.
# * attack_dmg: Self explanatory.
# * recoil_magnitude: The magnitude at which the character recoils.
# * solid: Boolean that determines whether the character is solid or no.
# * inv_frames: Amount of frames during which a character is invincible.
# * dying_frames: Amount of frames that lasts death animation.

require '../../src/obj/game_states'
require '../../src/obj/game_object'
require_relative 'hit_box'

class Char < GameObject

  attr_accessor :face_dir, :event_tiks, :current_speed, :current_hp, :total_hp, :recoil_frames, :attack_dmg,
                :recoil_magnitude, :solid, :inv_frames
  attr_reader   :dying_frames

  # Initializer Method
  # params:
  # - x,y,w,h: parameters for parent GameObject initializer
  # - solid: parameter that determines upon creation whether the character is in solid form or not.
  #
  # * Event tiks are set to 0 by default
  # * recoil frames by default is 35 frames, e.g. the character recoils for 35 frames.
  # * Invincibility frames is set to 0 by default.
  # * Dying frames is set to 20 by default, eg. the dying animation of a char lasts 20 frames.
  def initialize(x, y, w, h, solid)
    super(x, y, w, h)
    @event_tiks = 0
    @recoil_frames = 35
    @recoil_magnitude = 4
    @inv_frames = 0
    @dying_frames = 20
    @solid = solid
  end


  # Changes the direction the char is facing. Similar to change_state
  # params:
  # - dir: The dir of the new direction.
  def change_dir(dir)
    @face_dir = dir
    @sprite.change_dir(dir)
  end

  # Defines the behaviour of the character when it is impacted.
  # params:
  # - away_from: x,y coordinates that specify the point of origin of the attack.
  # - attack_dmg: the damage to be subtracted from the character's remaining health
  #
  # *Damage is subtracted from current health.
  # *An angle with respect to x,y axis is calculated between this char's hitbox and the coordinates given in the
  # argument
  # *Recoil speed in x and y is calculated using the former discussed angle and the recoil magnitude attribute
  # *State is changed to recoiling. This determines many things.
  # *Event Tiks is set equals to the recoil_frames or 18 if the char must die.

  def impacted(away_from, attack_dmg)
    @current_hp -= attack_dmg
    @vect_angle = Gosu.angle(away_from[0], away_from[1], @hb.x, @hb.y)
    @vect_v = @recoil_magnitude
    change_state(GameStates::States::RECOILING)
    @event_tiks = @current_hp > 0 ? @recoil_frames : 18
  end

  # Overrides parent class update method.
  # This override only implements unclipping functionality.
  # It calls basic move function.
  # Each 4 global frames, the character attepts to unclip from other game objects.
  # This action is not performed if the the char is either dying or attacking, or if it has invincibility frames.
  # It subtracts event tiks.
  # If event tiks reaches 0, the char's state changes to IDLE, unless current_hp is 0 or below, in which case
  # the char enters dying state.
  def update
    move
    if $WINDOW.global_frame_counter%4 == 0 && !(dying? || attacking?) && @inv_frames <= 0
      unclip
    end
    @event_tiks -=1 unless @event_tiks <= 0

    if recoiling? && @vect_v > 0
      fraction_event_tiks  = @event_tiks.to_f/@recoil_frames.to_f
      fraction_bigger_than = 1.00/3.00
      if fraction_event_tiks < fraction_bigger_than
        @vect_v = 0
      end
    end

    if @event_tiks <= 0 && @current_hp <=0
      change_state(GameStates::States::DYING)
      @event_tiks = @dying_frames
    end
  end

  # Main movement method.
  # It uses velocity
  # attributes to determine whether the char can move in both axes.
  # Changes the position of the hitbox in x and y if it can.
  def move
    if @vect_acc > 0 || @vect_acc < 0
      if (@vect_acc > 0 && @vect_v < @max_v) || (@vect_acc < 0 && @vect_v > @max_v)
        @vect_v += @vect_acc
      else
        @vect_v = @max_v
        @vect_acc = 0
      end
    end
    vel_x = Gosu.offset_x(@vect_angle, @vect_v)
    vel_y = Gosu.offset_y(@vect_angle, @vect_v)
    can_move_x = true
    can_move_y = true
    new_hitbox = HitBox.new(@hb.x+vel_x, @hb.y, @hb.w, @hb.h)
    $WINDOW.current_map.solid_tiles.each do |tile|
      if tile.hb.check_brute_collision(new_hitbox)
        can_move_x = false
      end
    end

    new_hitbox = HitBox.new(@hb.x, @hb.y+vel_y, @hb.w, @hb.h)
    $WINDOW.current_map.solid_tiles.each do |tile|
      if tile.hb.check_brute_collision(new_hitbox)
        can_move_y = false
      end
    end

    @hb.y += vel_y unless !can_move_x
    @hb.x += vel_x unless !can_move_y
  end

  # Method thar returns true if the char isn't recoiling or dying.
  def normal?
    return @state != GameStates::States::RECOILING && @state != GameStates::States::DYING
  end

  def dead?
    return dying? && @event_tiks <= 0
  end

  # This method moves the object so that when it finishes, it wont be clipping with anything
  def unclip
    loop do
      must_do = false
      $WINDOW.current_map.solid_game_objects.each do |ob|
        next if ob.id == 1 || ob.id == self.id
        if ob.hb.check_brute_collision(@hb)
          must_do = true
          clipping = true
          while (clipping)
            angle = Gosu.angle(ob.hb.x, ob.hb.y, @hb.x, @hb.y)
            add_x = Gosu.offset_x(angle, 1)
            add_y = Gosu.offset_y(angle, 1)
            place(@hb.x+add_x, @hb.y+add_y)
            if !ob.hb.check_brute_collision(@hb)
              clipping = false
            end
          end
        end
      end
      break if !must_do
    end
  end
end