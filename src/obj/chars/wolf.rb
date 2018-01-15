require 'gosu'
require '../../src/obj/chars/char'
require '../anims/wolf_sprite'
class Wolf < Char
  CHAR_ACC = 0.2
  CHAR_SPEED = 1

  def initialize
    super
    @face_dir = GameStates::FaceDir::LEFT
    @x = @y = 0
    @z = 1
    @w = 8
    @h = 10
    @sprite = WolfSprite.new
    @sprite_offset_x = -6
    @sprite_offset_y = -9

  end

  def update
    angle = Gosu.angle($WINDOW.player.x, $WINDOW.player.y, @x, @y)
    move_x = Gosu.offset_x(angle,1)
    move_y = Gosu.offset_y(angle,1)

    new_y = @y - move_y
    new_x = @x - move_x

    check_solids_collision(new_y, "y") ? return : @y = new_y
    check_solids_collision(new_x, "x") ? return : @x = new_x
  end

  def draw
    @sprite.animate(@x +@sprite_offset_x, @y+@sprite_offset_y, @z)
    if $WINDOW.draw_hb
      Gosu.draw_line(@x, @y, $WINDOW.color_blue, @x + @w, @y, $WINDOW.color_blue, 2)
      Gosu.draw_line(@x + @w, @y, $WINDOW.color_blue, @x + @w, @y + @h, $WINDOW.color_blue, 2)
      Gosu.draw_line(@x + @w, @y + @h, $WINDOW.color_blue, @x, @y + @h, $WINDOW.color_blue, 2)
      Gosu.draw_line(@x, @y + @h, $WINDOW.color_blue, @x, @y, $WINDOW.color_blue, 2)
    end
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