require '../../src/obj/others/poison_puff'
require '../anims/spitting_plant_sprite'
class SpittingPlant < Char
  ATTACK_PROBABILITY = 50

  def initialize(x, y)
    super(x, y, 10, 20, true)
    @face_dir = GameStates::FaceDir::LEFT
    @sprite = SpittingPlantSprite.new
    change_state(GameStates::States::IDLE)
    @attack_dmg = 2
    @until_next_attack_check = 100
    @total_hp = 2
    @current_hp = 2
    @recoil_magnitude = 0
    @dying_ticks = 40
  end

  def change_dir(diff_x,diff_y)
    diff_x > 0 ? @sprite.change_x(GameStates::FaceDir::LEFT) : @sprite.change_x(GameStates::FaceDir::RIGHT)
    diff_y > 0 ? @sprite.change_y(GameStates::FaceDir::DOWN) : @sprite.change_y(GameStates::FaceDir::UP)
  end

  def update
    diff_x = $WINDOW.player.hb.center[0] - @hb.center[0]
    diff_y = $WINDOW.player.hb.center[1] - @hb.center[1]

    if $WINDOW.global_frame_counter%4==0
      change_dir(diff_x,diff_y)
    end

    if idle? && Gosu.distance(@hb.x,@hb.y,$WINDOW.player.hb.x, $WINDOW.player.hb.y) < 100 && @until_next_attack_check <= 0
      if diff_x.abs < diff_y.abs
        change_dir(diff_x,diff_y)
        @until_next_attack_check = 70
        @face_dir = diff_y >= 0 ? GameStates::FaceDir::DOWN : GameStates::FaceDir::UP
        change_state(GameStates::States::ATTACKING)
      else
        change_dir(diff_x,diff_y)
        @until_next_attack_check = 70
        @face_dir = diff_x >= 0 ? GameStates::FaceDir::RIGHT : GameStates::FaceDir::LEFT
        change_state(GameStates::States::ATTACKING)
      end
    elsif attacking? && @event_tiks <= 0
      PoisonPuff.new(@hb.center[0],@hb.y, @face_dir)
      change_state(GameStates::States::IDLE)
    elsif recoiling?
      recoil
    elsif dying? && @event_tiks <= 0
      die
    end
    @event_tiks = @event_tiks > 0 ? @event_tiks - 1 : 0
    @until_next_attack_check = @until_next_attack_check > 0 ? @until_next_attack_check - 1 : 0
    super
  end

  def change_state(state)
    super(state)
    if state == GameStates::States::ATTACKING
      @event_tiks = 17
       if @face_dir == GameStates::FaceDir::UP
          @sprite.attacking = :attacking_top
       elsif @face_dir == GameStates::FaceDir::DOWN
         @sprite.attacking = :attacking_bot
       else
         @sprite.attacking = :attacking_side
       end
    end
  end
end