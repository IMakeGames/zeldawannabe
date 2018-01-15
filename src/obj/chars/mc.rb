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

  def update
    if moving?
      move
    end
  end

  def change_move_state(action)
    if action == GameStates::Action::PRESS && self.idle?
      @state = GameStates::States::MOVING
    elsif action == GameStates::Action::RELEASE && self.moving?
      @state = GameStates::States::IDLE
    end
    @sprite.change_state(@state)
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
    if $WINDOW.draw_hb
      Gosu.draw_line(@x, @y, $WINDOW.color_blue, @x + @w, @y, $WINDOW.color_blue, 2)
      Gosu.draw_line(@x + @w, @y, $WINDOW.color_blue, @x + @w, @y + @h, $WINDOW.color_blue, 2)
      Gosu.draw_line(@x + @w, @y + @h, $WINDOW.color_blue, @x, @y + @h, $WINDOW.color_blue, 2)
      Gosu.draw_line(@x, @y + @h, $WINDOW.color_blue, @x, @y, $WINDOW.color_blue, 2)
    end
  end
end