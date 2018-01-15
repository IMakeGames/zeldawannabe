require 'gosu'
require '../../src/obj/chars/char'
require '../anims/mc_sprite'
class Mc < Char
  CHAR_ACC = 0.2
  CHAR_SPEED = 2

  def initialize
    super
    @x = @y = 0
    @z = 1
    @w = 8
    @h = 10
    @sprite = McSprite.new
    @sprite_offset_x = -6
    @sprite_offset_y = -9
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def move
    case @face_dir
      when GameStates::FaceDir::UP
        new_y = @y - CHAR_SPEED
        check_solids_collision(new_y, "y") ? return : @y = new_y
      when GameStates::FaceDir::RIGHT
        new_x = @x + CHAR_SPEED
        check_solids_collision(new_x+@w, "x") ? return : @x = new_x
      when GameStates::FaceDir::DOWN
        new_y = @y + CHAR_SPEED
        check_solids_collision(new_y + @h, "y") ? return : @y = new_y
      when GameStates::FaceDir::LEFT
        new_x = @x - CHAR_SPEED
        check_solids_collision(new_x, "x") ? return : @x = new_x
    end
  end

  def draw
    @sprite.animate(@x +@sprite_offset_x, @y+@sprite_offset_y, @z)
    if $DRAW_HB
      Gosu.draw_line(@x, @y, $COLOR_BLUE, @x + @w, @y, $COLOR_BLUE, 2)
      Gosu.draw_line(@x + @w, @y, $COLOR_BLUE, @x + @w, @y + @h, $COLOR_BLUE, 2)
      Gosu.draw_line(@x + @w, @y + @h, $COLOR_BLUE, @x, @y + @h, $COLOR_BLUE, 2)
      Gosu.draw_line(@x, @y + @h, $COLOR_BLUE, @x, @y, $COLOR_BLUE, 2)
    end
  end

  def check_solids_collision(new_coord, axis)
    case axis
      when "x"
        $CURRENT_MAP.solid_tiles.each do |tile|
          if @y.between?(tile.y, tile.y+tile.h) || (@y+@h).between?(tile.y, tile.y+tile.h)
            if new_coord <= tile.x + 12 && new_coord >= tile.x
              tile.impact = true
              return true
            end
          end
        end
        return false
      when "y"
        $CURRENT_MAP.solid_tiles.each do |tile|
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