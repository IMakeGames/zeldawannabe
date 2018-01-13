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
    @sprite = McSprite.new
    @anim_tik = 0
  end

  def warp(x,y)
    @x, @y = x, y
  end

  def move
    case self.face_dir
      when GameStates::FaceDir::UP
        @y -= CHAR_SPEED
      when GameStates::FaceDir::RIGHT
        @x += CHAR_SPEED
      when GameStates::FaceDir::DOWN
        @y += CHAR_SPEED
      when GameStates::FaceDir::LEFT
        @x -= CHAR_SPEED
    end
  end

  def draw
    @sprite.animate(@x, @y, @z)
  end
end