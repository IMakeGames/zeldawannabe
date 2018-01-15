require '../../src/obj/game_states'

class Char
  attr_accessor :state, :face_dir, :x, :y, :w, :h, :sprite_offset_x, :sprite_offset_y

  def initialize
    @state =  GameStates::States::IDLE
    @face_dir = GameStates::FaceDir::DOWN
    @sprite = nil
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
    @x, @y = x, y
  end

  def change_dir(dir)
    @face_dir = dir
    @sprite.change_dir(dir)
  end

  def update
    raise "UPDATE METHOD MUST BE OVERRIDEN"
  end

  def check_solids_collision(new_coord, axis)
    case axis
      when "x"
        $WINDOW.current_map.solid_tiles.each do |tile|
          if @y.between?(tile.y, tile.y+tile.h) || (@y+@h).between?(tile.y, tile.y+tile.h)
            if new_coord <= tile.x + 12 && new_coord >= tile.x
              tile.impact = true
              return true
            end
          end
        end
        return false
      when "y"
        $WINDOW.current_map.solid_tiles.each do |tile|
          if @x.between?(tile.x, tile.x+tile.w) || (@x+@w).between?(tile.x, tile.x+tile.w)
            if new_coord <= tile.y + 12 && new_coord >= tile.y
              tile.impact = true
              return true
            end
          end
        end
        return false
    end
  end
end