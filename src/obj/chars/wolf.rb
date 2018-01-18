require 'gosu'
require '../../src/obj/chars/char'
require '../anims/wolf_sprite'
class Wolf < Char
  CHAR_ACC = 0.2

  def initialize(x, y)
    super(x, y, 8, 10)
    @face_dir = GameStates::FaceDir::LEFT
    @sprite = WolfSprite.new
    @sprite_offset_x = -6
    @sprite_offset_y = -9
    @char_speed
    @hp = 3
  end

  def update
    if @hp <= 0
      die
    elsif moving?
      angle = Gosu.angle($WINDOW.player.hb.x, $WINDOW.player.hb.y, @hb.x, @hb.y)
      move_x = Gosu.offset_x(angle,1)
      move_y = Gosu.offset_y(angle,1)
      new_hitbox = HitBox.new(@hb.x - move_x, @hb.y - move_y, @hb.w, @hb.h)
      $WINDOW.current_map.solid_hbs.each do |hbs|
        if hbs.check_brute_collision(new_hitbox)
          return
        end
      end
      @hb.x -= move_x
      @hb.y -= move_y
    elsif attacking?
      perform_attack
    elsif recoiling?
      recoil
    end
  end

end