require '../../src/obj/chars/char'
require '../anims/bat_sprite'
class Bat < Char
  CHAR_ACC = 0.2

  def initialize(x, y)
    super(x, y, 3, 4, false)
    @sprite = BatSprite.new
    change_state(GameStates::States::IDLE)
    @attack_dmg = 1
    @total_hp = 2
    @current_hp = 2
    @approaching = true
  end

  def update
    if idle?
      if Gosu.distance(@hb.x, @hb.y, $WINDOW.player.hb.x, $WINDOW.player.hb.y) < 75
        change_state(GameStates::States::MOVING)
      end
    elsif moving?
      if Gosu.distance(@hb.x, @hb.y, $WINDOW.player.hb.x, $WINDOW.player.hb.y) > 50 && @approaching
        approach($WINDOW.player,2)
      elsif @event_tiks > 0
        @approaching ? approach($WINDOW.player,1) : distance_from($WINDOW.player,2)
      else
        decide_what_to_do_next
      end
    elsif attacking?
      if @event_tiks > 0
        if @attack_type == :random
          @hb.x += 3*@dir*@axis_x
          @hb.y += 3*@dir*@axis_y
          @dir = @event_tiks == 17 ? -1*@dir : @dir
        elsif @attack_type == :dart
          @hb.x -= @attack_x_speed
          @hb.y -= @attack_y_speed
        end
      else
        change_state(GameStates::States::MOVING)
        @event_tiks = @approaching ? 60 : 15
      end
    elsif recoiling?
      recoil
    elsif dying?
      @event_tiks == 0 ? die : nil
    end

    if normal? && $WINDOW.player.inv_frames <= 0 && !$WINDOW.player.recoiling? && @hb.check_brute_collision($WINDOW.player.hb)
      $WINDOW.player.impacted(@hb.center, @attack_dmg)
    end

    if !idle? && Gosu.distance(@hb.x, @hb.y, $WINDOW.player.hb.x, $WINDOW.player.hb.y) > 250
      change_state(GameStates::States::IDLE)
    end

    @event_tiks -= 1 unless recoiling? || (Gosu.distance(@hb.x, @hb.y, $WINDOW.player.hb.x, $WINDOW.player.hb.y) > 50 && !attacking? && @approaching)
  end

  def rotate
    mag = Gosu.distance(@hb.x, @hb.y, $WINDOW.player.hb.x, $WINDOW.player.hb.y)
    angl = Gosu.angle(@hb.x, @hb.y, $WINDOW.player.hb.x, $WINDOW.player.hb.y)
    move_x = Gosu.offset_x(angl-3, 1)
    move_y = Gosu.offset_y(angl-3, 1)

    @hb.x += move_x
    @hb.y -= move_y
  end

  def calc_randoms
    dieroll = Random.rand(100)

    @dir = @hb.x > $WINDOW.player.hb.x ? -1 : 1

    if dieroll.between?(0, 25)
      @axis_x = 1
      @axis_y = 0
    elsif dieroll.between?(26, 50)
      @axis_x = 0
      @axis_y = 1
    elsif dieroll.between?(51, 75)
      @axis_x = 1
      @axis_y = 1
    elsif dieroll.between?(76, 100)
      @axis_x = 1
      @axis_y = -1
    end
  end

  def decide_what_to_do_next
    dieroll = Random.rand(100)
    if dieroll.between?(0,41)
      @approaching = !@approaching
      change_state(GameStates::States::MOVING)
      @event_tiks = @approaching ? 60 : 15
    else
      change_state(GameStates::States::ATTACKING)
    end
  end

  #TODO: CREATE IDLE STATE
  def change_state(state)
    super(state)
    case state
      when GameStates::States::MOVING
      when GameStates::States::ATTACKING
        dieroll = Random.rand(100)
        if dieroll.between?(0, 70)
          @attack_type = :random
          calc_randoms
          @event_tiks = 30
        elsif dieroll.between?(71, 100)
          @attack_type = :dart
          angle = Gosu.angle($WINDOW.player.hb.x, $WINDOW.player.hb.y, @hb.x, @hb.y)
          @attack_x_speed = Gosu.offset_x(angle, 3)
          @attack_y_speed = Gosu.offset_y(angle, 3)
          @event_tiks = 28
        end
      when GameStates::States::DYING
        @event_tiks = 30
    end
  end
end