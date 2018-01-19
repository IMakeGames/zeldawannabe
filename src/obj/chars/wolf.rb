require 'gosu'
require '../../src/obj/chars/char'
require '../anims/wolf_sprite'
class Wolf < Char
  CHAR_ACC = 0.2
  ATTACK_PROBABILITY = 40

  def initialize(x, y)
    super(x, y, 6, 8)
    @face_dir = GameStates::FaceDir::LEFT
    @sprite = WolfSprite.new
    @attack_x_speed = 0
    @attack_y_speed = 0
    @until_next_attack_check = 120
    @hp = 4
  end

  def update
    if moving?
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
      if @until_next_attack_check <= 0
        dieroll = Gosu.random(1,101)
        if dieroll <= ATTACK_PROBABILITY
          puts "GONNA ATTACK"
          change_state(GameStates::States::ATTACKING)
          @event_tiks =60
        end
      else
        @until_next_attack_check -= 1
      end
      if move_x < 0
        change_dir( GameStates::FaceDir::RIGHT)
      else
        change_dir( GameStates::FaceDir::LEFT)
      end
    elsif attacking?
      perform_attack
    elsif recoiling?
      recoil
    elsif dying?
      @event_tiks == 0 ? $WINDOW.current_map.enemies.delete(self) : @event_tiks -= 1
    end

    if normal? && $WINDOW.player.invis_frames <= 0 && !$WINDOW.player.recoiling? && @hb.check_brute_collision($WINDOW.player.hb)
      $WINDOW.player.impacted(@hb.midpoint)
    end
  end

  def perform_attack
    @event_tiks -= 1
    if @event_tiks == 20
      angle = Gosu.angle($WINDOW.player.hb.x, $WINDOW.player.hb.y, @hb.x, @hb.y)
      @attack_x_speed = Gosu.offset_x(angle,3)
      @attack_y_speed = Gosu.offset_y(angle,3)
    end
    if @event_tiks <= 20 && @event_tiks > 0
    new_hitbox = HitBox.new(@hb.x - @attack_x_speed, @hb.y - @attack_y_speed, @hb.w, @hb.h)
      $WINDOW.current_map.solid_hbs.each do |hbs|
        if hbs.check_brute_collision(new_hitbox)
          return
        end
      end
      @hb.x -= @attack_x_speed
      @hb.y -= @attack_y_speed
    end
    if @event_tiks <= 0
      change_state(GameStates::States::MOVING)
      @until_next_attack_check = 120
    end
  end

  def change_state(state)
    super(state)
    if state == GameStates::States::ATTACKING
      @sprite.change_state(GameStates::States::CUSTOM)
    end
  end
end