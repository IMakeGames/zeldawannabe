require '../../src/obj/game_states'
require_relative 'hit_box'

class Char
  attr_accessor :state, :face_dir, :sprite_offset_x, :sprite_offset_y, :action_tiks, :hb, :char_speed

  def initialize(x,y,w,h)
    @state =  GameStates::States::IDLE
    @sprite = nil
    @action_tiks = 0
    @hb = HitBox.new(x,y,w,h)
  end

  def idle?
    return @state ==  GameStates::States::IDLE
  end

  def moving?
    return @state ==  GameStates::States::MOVING
  end

  def attacking?
    return @state ==  GameStates::States::ATTACKING
  end

  def recoiling?
    return @state ==  GameStates::States::RECOILING
  end


  def place(x, y)
    @hb.place(x,y)
  end

  def change_dir(dir)
    @face_dir = dir
    @sprite.change_dir(dir)
  end

  def update
    raise "UPDATE METHOD MUST BE OVERRIDEN"
  end

  def draw
    if $WINDOW.draw_hb
      @hb.draw
    end
    @sprite.animate(@hb.x, @hb.y, 1)
  end

  def move
    case @face_dir
      when GameStates::FaceDir::UP
        x1 = @hb.x
        x2 = @hb.x + @hb.w
        y1 = @hb.y - char_speed
        $WINDOW.current_map.solid_hbs.each do |hbs|
          if hbs.check_point_collision(x1,y1) || hbs.check_point_collision(x2,y1)
            return
          end
        end
        @hb.y -= char_speed
      when GameStates::FaceDir::RIGHT
        x1 = @hb.x + @hb.w + char_speed
        y1 = @hb.y
        y2 = @hb.y + @hb.h
        $WINDOW.current_map.solid_hbs.each do |hbs|
          if hbs.check_point_collision(x1,y1) || hbs.check_point_collision(x1,y2)
            return
          end
        end
        @hb.x += char_speed
      when GameStates::FaceDir::DOWN
        x1 = @hb.x
        x2 = @hb.x + @hb.w
        y1 = @hb.y + @hb.h + char_speed
        $WINDOW.current_map.solid_hbs.each do |hbs|
          if hbs.check_point_collision(x1,y1) || hbs.check_point_collision(x2,y1)
            return
          end
        end
        @hb.y += char_speed
      when GameStates::FaceDir::LEFT
        x1 = @hb.x - char_speed
        y1 = @hb.y
        y2 = @hb.y + @hb.h
        $WINDOW.current_map.solid_hbs.each do |hbs|
          if hbs.check_point_collision(x1,y1) || hbs.check_point_collision(x1,y2)
            return
          end
        end
        @hb.x -= char_speed
    end
  end
end