require 'gosu'
require '../../src/obj/chars/char'
require '../anims/wolf_sprite'
class Wolf < Char
  CHAR_ACC = 0.2
  ATTACK_PROBABILITY = 35

  def initialize(x, y)
    super(x, y, 6, 8)
    @face_dir = GameStates::FaceDir::LEFT
    @sprite = WolfSprite.new
    change_state(GameStates::States::IDLE)
    @attack_x_speed = 0
    @attack_y_speed = 0
    @attack_dmg = 2
    @until_next_attack_check = 100
    @total_hp = 4
    @current_hp = 4
  end

  def update
    if idle?
      if Gosu.distance(@hb.x,@hb.y,$WINDOW.player.hb.x, $WINDOW.player.hb.y) < 150
        change_state(GameStates::States::MOVING)
      end
    elsif moving?
      angle = Gosu.angle($WINDOW.player.hb.x, $WINDOW.player.hb.y, @hb.x, @hb.y)
      move_x = Gosu.offset_x(angle,1)
      move_y = Gosu.offset_y(angle,1)

      new_hitbox = HitBox.new(@hb.x - move_x, @hb.y, @hb.w, @hb.h)
      $WINDOW.current_map.game_objects.each do |ob|
        next if ob.id == 1 || ob.id == self.id
        if ob.hb.check_brute_collision(new_hitbox)
          @can_move_x = false
          break
        end
      end

      new_hitbox = HitBox.new(@hb.x, @hb.y - move_y, @hb.w, @hb.h)
      $WINDOW.current_map.game_objects.each do |ob|
        next if ob.id == 1 || ob.id == self.id
        if ob.hb.check_brute_collision(new_hitbox)
          @can_move_y = false
          break
        end
      end

      @hb.x = @can_move_x ? @hb.x - move_x : @hb.x
      @hb.y = @can_move_y ? @hb.y - move_y : @hb.y

      if @until_next_attack_check <= 0
        dieroll = Gosu.random(1,101)
        if dieroll <= ATTACK_PROBABILITY
          puts "GONNA ATTACK"
          change_state(GameStates::States::ATTACKING)
          @event_tiks =60
        else
          @until_next_attack_check = 30
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
      $WINDOW.player.impacted(@hb.midpoint, @attack_dmg)
    end

    if Gosu.distance(@hb.x,@hb.y,$WINDOW.player.hb.x, $WINDOW.player.hb.y) > 250
      change_state(GameStates:States::IDLE)
    end

    @can_move_x = true
    @can_move_y = true

  end

  def perform_attack
    @event_tiks -= 1
    if @event_tiks >= 20
      angle = Gosu.angle($WINDOW.player.hb.x, $WINDOW.player.hb.y, @hb.x, @hb.y)
      @attack_x_speed = Gosu.offset_x(angle,3)
      @attack_y_speed = Gosu.offset_y(angle,3)
      if @attack_x_speed < 0
        change_dir( GameStates::FaceDir::RIGHT)
      else
        change_dir( GameStates::FaceDir::LEFT)
      end
    end
    if @event_tiks <= 20 && @event_tiks > 0
    new_hitbox = HitBox.new(@hb.x - @attack_x_speed, @hb.y - @attack_y_speed, @hb.w, @hb.h)
      $WINDOW.current_map.solid_tiles.each do |tile|
        if tile.hb.check_brute_collision(new_hitbox)
          return
        end
      end
      @hb.x -= @attack_x_speed
      @hb.y -= @attack_y_speed
    end
    if @event_tiks <= -15
      change_state(GameStates::States::IDLE)
      @until_next_attack_check = 100
    end
  end

  def change_state(state)
    super(state)
    if state == GameStates::States::ATTACKING
      @sprite.change_state(GameStates::States::CUSTOM)
    end
  end
end