require 'gosu'
require '../../src/obj/chars/char'
require '../anims/wolf_sprite'
class Wolf < Char
  CHAR_ACC = 0.2

  def initialize
    super(0,0,8,10)
    @face_dir = GameStates::FaceDir::LEFT
    @sprite = WolfSprite.new
    @sprite_offset_x = -6
    @sprite_offset_y = -9
    @char_speed
  end

  def update
    # angle = Gosu.angle($WINDOW.player.x, $WINDOW.player.y, @x, @y)
    # move_x = Gosu.offset_x(angle,1)
    # move_y = Gosu.offset_y(angle,1)
    #
    # new_y = @y - move_y
    # new_x = @x - move_x
    #
    # check_solids_collision(new_y, "y") ? return : @y = new_y
    # check_solids_collision(new_x, "x") ? return : @x = new_x
  end

end