require '../../src/obj/chars/char'
require '../anims/boar_sprite'
class Boar < Char

  def initialize(x, y)
    super(x, y, 6, 8, true)
    @face_dir = GameStates::FaceDir::LEFT
    @sprite = BoarSprite.new
    change_state(GameStates::States::IDLE)
    @attack_dmg = 3
    @total_hp = 4
    @current_hp = 4
    @attack_speed = 3
  end

  def impacted(away_from, attack_dmg)
    @current_hp -= attack_dmg
    @sprite.impacted = true
    @inv_frames = @current_hp > 0 ? 40 : 18
  end

  def update
    if idle?
      if Gosu.distance(@hb.x,@hb.y,$WINDOW.player.hb.x, $WINDOW.player.hb.y) < 75
        change_state(GameStates::States::MOVING)
      end
    elsif moving?
      diff_x = $WINDOW.player.hb.center[0] - @hb.center[0]
      diff_y = $WINDOW.player.hb.center[1] - @hb.center[1]

      if diff_x.between?(-1*($WINDOW.player.hb.w/2),$WINDOW.player.hb.w/2)

        @axis = :y
        @orientation = diff_y > 0 ? 1 : -1
        change_state(GameStates::States::ATTACKING)
      elsif diff_y.between?(-1*($WINDOW.player.hb.h/2),$WINDOW.player.hb.h/2)
        @axis = :x
        @orientation = diff_x > 0 ? 1 : -1
        change_state(GameStates::States::ATTACKING)
      else
        @axis = diff_x.abs < diff_y.abs ? :x : :y
        @orientation = @axis == :x ? (diff_x > 0 ? 1 : -1) : (diff_y > 0 ? 1 : -1)
        move(0.5)
      end
      diff_x > 0 ? change_dir(GameStates::FaceDir::RIGHT) : change_dir(GameStates::FaceDir::LEFT)
    elsif attacking? && @event_tiks == 0
      not_moved = move(4)
      if not_moved
        change_state(GameStates::States::RECOILING)
      end
    elsif recoiling?
      recoil
    end

    if normal? && $WINDOW.player.inv_frames <= 0 && !$WINDOW.player.recoiling? && @hb.check_brute_collision($WINDOW.player.hb)
      $WINDOW.player.impacted(@hb.center, @attack_dmg)
    end

    if !idle? && Gosu.distance(@hb.x,@hb.y,$WINDOW.player.hb.x, $WINDOW.player.hb.y) > 250
      change_state(GameStates:States::IDLE)
    end

    @event_tiks > 0 ? @event_tiks -= 1 : ((@event_tiks <= 0 && dying?) ? die : @event_tiks = @event_tiks)

    if @inv_frames > 0
      @inv_frames -= 1
    elsif @sprite.impacted && @current_hp <= 0 && !dying?
      change_state(GameStates::States::DYING)
      @event_tiks = 20
    elsif @sprite.impacted
       @sprite.impacted = false
    end
    super unless attacking? || recoiling? || dying?
  end

  def recoil
    move(0.7) unless @event_tiks < 15
    @event_tiks <= 0 ? change_state(GameStates::States::MOVING) : nil
  end

  def move(magnitude)
    if @axis == :x
      returning = move_in_x(magnitude,@orientation)
    else
      returning = move_in_y(magnitude,@orientation)
    end
    return returning
  end

  def change_state(state)
    super(state)
    case @state
      when GameStates::States::ATTACKING
        @event_tiks = 40
      when GameStates::States::RECOILING
        @event_tiks = 50
        @orientation = -@orientation
    end
  end
end