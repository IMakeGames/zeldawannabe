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
  attr_reader :recoil_speed_y, :recoil_speed_x, :dying_frames

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
    angle = Gosu.angle(away_from[0], away_from[1], @hb.x, @hb.y)
    @recoil_speed_x = Gosu.offset_x(angle, @recoil_magnitude)
    @recoil_speed_y = Gosu.offset_y(angle, @recoil_magnitude)
    change_state(GameStates::States::RECOILING)
    @event_tiks = @current_hp > 0 ? @recoil_frames : 18
  end

  # Overrides parent class update method.
  # This override only implements unclipping functionality.
  # Each 4 global frames, the character attepts to unclip from other game objects.
  # This action is not performed if the the char is either dying or attacking, or if it has invincibility frames.
  def update
    if $WINDOW.global_frame_counter%4 == 0 && !(dying? || attacking?) && @inv_frames <= 0
      unclip
    end
  end

  # Method that performs recoil behaviour for the char.
  #
  def recoil
    if @event_tiks > (@recoil_frames*0.61).ceil && @event_tiks < (@recoil_frames*0.893).ceil
      new_hitbox = HitBox.new(@hb.x + @recoil_speed_x, @hb.y + @recoil_speed_y, @hb.w, @hb.h)
      $WINDOW.current_map.solid_tiles.each do |tile|
        if tile.hb.check_brute_collision(new_hitbox)
          @event_tiks -= 1
          return
        end
      end
      @hb.x += @recoil_speed_x
      @hb.y += @recoil_speed_y
    elsif @event_tiks <= 0
      if @current_hp <=0
        change_state(GameStates::States::DYING)
        @event_tiks = @dying_frames
      elsif !blocking?
        change_state(GameStates::States::IDLE)
      end
    end
    @event_tiks -=1
  end

  def approach(object, magnitude)
    @can_move_x = true
    @can_move_y = true
    angle = Gosu.angle(object.hb.x, object.hb.y, @hb.x, @hb.y)
    move_x = Gosu.offset_x(angle, magnitude)
    move_y = Gosu.offset_y(angle, magnitude)

    if @solid
      new_hitbox = HitBox.new(@hb.x - move_x, @hb.y, @hb.w, @hb.h)
      $WINDOW.current_map.solid_game_objects.each do |ob|
        next if ob.id == 1 || ob.id == self.id
        if ob.hb.check_brute_collision(new_hitbox)
          @can_move_x = false
          break
        end
      end

      new_hitbox = HitBox.new(@hb.x, @hb.y - move_y, @hb.w, @hb.h)
      $WINDOW.current_map.solid_game_objects.each do |ob|
        next if ob.id == 1 || ob.id == self.id
        if ob.hb.check_brute_collision(new_hitbox)
          @can_move_y = false
          break
        end
      end
    end

    @hb.x = @can_move_x ? @hb.x - move_x : @hb.x
    @hb.y = @can_move_y ? @hb.y - move_y : @hb.y

    return move_x
  end

  def distance_from(object,magnitude)
    approach(object,-1*magnitude)
  end

  def move
    case @face_dir
      when GameStates::FaceDir::UP
        move_in_y(@current_speed,-1)
      when GameStates::FaceDir::RIGHT
        move_in_x(@current_speed,1)
      when GameStates::FaceDir::DOWN
        move_in_y(@current_speed,1)
      when GameStates::FaceDir::LEFT
        move_in_x(@current_speed,-1)
    end
  end

  def move_in_x(mag,orientation)
    move_x = mag * orientation
    new_hitbox = HitBox.new(@hb.x+move_x, @hb.y, @hb.w, @hb.h)
    $WINDOW.current_map.solid_tiles.each do |tile|
      if tile.hb.check_brute_collision(new_hitbox)
        return true
      end
    end
    @hb.x += move_x
    return false
  end

  def move_in_y(mag,orientation)
    move_y = mag*orientation
    new_hitbox = HitBox.new(@hb.x, @hb.y+move_y, @hb.w, @hb.h)
    $WINDOW.current_map.solid_tiles.each do |tile|
      if tile.hb.check_brute_collision(new_hitbox)
        return true
      end
    end
    @hb.y += move_y
    return false
  end

  def normal?
    return @state != GameStates::States::RECOILING && @state != GameStates::States::DYING
  end

  #TODO: THIS METHOD IS EXPERIMENTAL, IT WILL PROBABLY NEED MUCH MORE WORK. TO DO PENDANT
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