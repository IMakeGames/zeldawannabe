require '../../src/obj/game_states'
require_relative 'hit_box'

class Char
  attr_accessor :state, :face_dir, :sprite_offset_x, :sprite_offset_y, :event_tiks, :hb, :char_speed, :hp

  def initialize(x, y, w, h)
    @sprite = nil
    @event_tiks = 0
    @hb = HitBox.new(x, y, w, h)
    @recoil_speed_x
    @recoil_speed_y
  end

  def idle?
    return @state == GameStates::States::IDLE
  end

  def moving?
    return @state == GameStates::States::MOVING
  end

  def attacking?
    return @state == GameStates::States::ATTACKING
  end

  def recoiling?
    return @state == GameStates::States::RECOILING
  end

  def dying?
    return @state == GameStates::States::DYING
  end

  def place(x, y)
    @hb.place(x, y)
  end

  def change_dir(dir)
    @face_dir = dir
    @sprite.change_dir(dir)
  end

  def change_state(id)
    @state = id
    @sprite.change_state(id)
  end

  def impacted(away_from)
    @hp -= 1
    angle = Gosu.angle(away_from[0], away_from[1], @hb.x, @hb.y)
    @recoil_speed_x = Gosu.offset_x(angle, 3)
    @recoil_speed_y = Gosu.offset_y(angle, 3)
    change_state(GameStates::States::RECOILING)
    @event_tiks = 25
  end

  def update
    raise "UPDATE METHOD MUST BE OVERRIDEN"
  end

  def recoil
    if @event_tiks > 17
      new_hitbox = HitBox.new(@hb.x + @recoil_speed_x, @hb.y + @recoil_speed_y, @hb.w, @hb.h)
      $WINDOW.current_map.solid_hbs.each do |hbs|
        if hbs.check_brute_collision(new_hitbox)
          @event_tiks -= 1
          return
        end
      end
      @hb.x += @recoil_speed_x
      @hb.y += @recoil_speed_y
    elsif @event_tiks <= 0
      change_state(GameStates::States::MOVING)
    end
    @event_tiks -=1
  end

  def draw
    if $WINDOW.draw_hb
      @hb.draw
    end
    @sprite.animate_linear(@hb.x, @hb.y, 1)
  end

  def move
    case @face_dir
      when GameStates::FaceDir::UP
        new_hitbox = HitBox.new(@hb.x, @hb.y - char_speed, @hb.w, @hb.h)
        $WINDOW.current_map.solid_hbs.each do |hbs|
          if hbs.check_brute_collision(new_hitbox)
            return
          end
        end
        @hb.y -= char_speed
      when GameStates::FaceDir::RIGHT
        new_hitbox = HitBox.new(@hb.x+char_speed, @hb.y, @hb.w, @hb.h)
        $WINDOW.current_map.solid_hbs.each do |hbs|
          if hbs.check_brute_collision(new_hitbox)
            return
          end
        end
        @hb.x += char_speed
      when GameStates::FaceDir::DOWN
        new_hitbox = HitBox.new(@hb.x, @hb.y + char_speed, @hb.w, @hb.h)
        $WINDOW.current_map.solid_hbs.each do |hbs|
          if hbs.check_brute_collision(new_hitbox)
            return
          end
        end
        @hb.y += char_speed
      when GameStates::FaceDir::LEFT
        new_hitbox = HitBox.new(@hb.x - char_speed, @hb.y, @hb.w, @hb.h)
        $WINDOW.current_map.solid_hbs.each do |hbs|
          if hbs.check_brute_collision(new_hitbox)
            return
          end
        end
        @hb.x -= char_speed
    end
  end
end