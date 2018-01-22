require '../../src/obj/game_states'
require '../../src/obj/game_object'
require_relative 'hit_box'

class Char < GameObject

  attr_accessor :state, :face_dir, :event_tiks, :char_speed, :current_hp, :total_hp, :recoil_ticks, :attack_dmg,
                :recoil_magnitude, :solid, :invis_frames

  def initialize(x, y, w, h, solid)
    super(x, y, w, h)
    @event_tiks = 0
    @recoil_ticks = 35
    @recoil_speed_x
    @recoil_speed_y
    @recoil_magnitude = 4
    @invis_frames = 0
    @solid = solid
  end

  def change_dir(dir)
    @face_dir = dir
    @sprite.change_dir(dir)
  end

  def impacted(away_from, attack_dmg)
    @current_hp -= attack_dmg
    angle = Gosu.angle(away_from[0], away_from[1], @hb.x, @hb.y)
    @recoil_speed_x = Gosu.offset_x(angle, @recoil_magnitude)
    @recoil_speed_y = Gosu.offset_y(angle, @recoil_magnitude)
    change_state(GameStates::States::RECOILING)
    @event_tiks = @current_hp > 0 ? @recoil_ticks : 18
  end

  #TODO: THE TICKS SUBTRACTING AT THE END OF UPDATE IS RATHER CONFUSING AND PERHAPS IT WOULD BE A GOOD IDEA TO WORK TOWARDS ORGINIZING IT
  def update

    #TODO UNCLIPS EVERY 4 FRAMES
    if $WINDOW.global_frame_counter%4 == 0 && !(dying? || attacking?) && @invis_frames <= 0
      unclip
    end
  end

  def recoil
    if @event_tiks > (@recoil_ticks*0.61).ceil && @event_tiks < (@recoil_ticks*0.893).ceil
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
        @event_tiks = 20
      else
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
        move_in_y(char_speed,-1)
      when GameStates::FaceDir::RIGHT
        move_in_x(char_speed,1)
      when GameStates::FaceDir::DOWN
        move_in_y(char_speed,1)
      when GameStates::FaceDir::LEFT
        move_in_x(char_speed,-1)
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