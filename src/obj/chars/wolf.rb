# Wolf MOB Class Class.
# Inherits from Char Class
# Class Attributes:
#  *ATTACK_PROBABILITY: Likelyhood that this mob will attack
#  *sah: Sword attack hitboxes, an array of hitboxes that compose a sword attack.
#  *una_tiks: Until Next Attack Tiks, counter that determines time before the next attack can be performed.
#  *unr_tiks: Until Next Roll Tiks, counter that determines time before the next roll can be performed.
#  *uns_frames: Unitl Next Sheathe Tiks, counter that determines time before next sheath/unsheathe can be performed
#  *sia: Sword Initial Angle, angle in degrees of the initial sword attack.
#  *unseathed: boolean attribute that determines whether the main character is in an unsheathed state or not.
#  *command_stack: Storage for inputed keys and actions.
#  *changed_command_stack: Indicates whether command_stack has been changed for taking action


require_relative'../../obj/chars/char'
require_relative'../anims/wolf_sprite'
class Wolf < Char
  ATTACK_PROBABILITY = 0.5

  def initialize(x, y)
    super(x, y, 6, 8, true)
    @face_dir = GameStates::FaceDir::LEFT
    @sprite = WolfSprite.new
    change_state(GameStates::States::IDLE)
    @attack_dmg = 2
    @una_check_tiks = 100                        # Number of tiks after which update will check if attack or not.
    @total_hp = @current_hp = 4
  end

  # Update behavior is different from Main Char's because it checks on update.
  def update
    if idle?
      if Gosu.distance(@hb.x,@hb.y,$WINDOW.player.hb.x, $WINDOW.player.hb.y) < 150
        # If distance is 150 or less, behaviour changes to approaching
        change_state(GameStates::States::WALKING)
        @vect_v = 1
        @vect_angle = Gosu.angle(@hb.x, @hb.y, $WINDOW.player.hb.x, $WINDOW.player.hb.y)
      end
    elsif walking?
      # While walking, wolf tries to approach the main character
      @vect_angle = Gosu.angle(@hb.x, @hb.y, $WINDOW.player.hb.x, $WINDOW.player.hb.y)
      if @una_check_tiks <= 0
        # When next attack check counter reaches 0, wolf can attack.
        dieroll = Random.rand
        if dieroll <= ATTACK_PROBABILITY
          # If random is within attack probability, the wolf changes behaviour to attack
          change_state(GameStates::States::ATTACKING)
          @event_tiks =60
          @vect_v = 0
        else
          #If random is not within attack probability, next attack check counter is reset to 30.
          @una_check_tiks = 30
        end
      end
      check_change_dir
    elsif attacking?
      # If attacking, wolf waits for a little while, then charges in a straight line. Then waits a little while.
      if @event_tiks > 20
        check_change_dir
      elsif @event_tiks == 20
        @vect_angle = Gosu.angle(@hb.x, @hb.y, $WINDOW.player.hb.x, $WINDOW.player.hb.y)
        @vect_v = 3.5
      elsif @event_tiks == 10
        @venct_v = 0
      elsif @event_tiks <= 0
        change_state(GameStates::States::IDLE)
        @una_check_tiks = 100
      end
    end

    if normal? && $WINDOW.player.inv_frames <= 0 && !$WINDOW.player.recoiling? && @hb.check_brute_collision($WINDOW.player.hb)
      # If it connects with player, player is set to impacted.
      $WINDOW.player.impacted(@hb.center, @attack_dmg)
    end

    if !idle? && Gosu.distance(@hb.x,@hb.y,$WINDOW.player.hb.x, $WINDOW.player.hb.y) > 250
      #If distance surpasses 250, the wolf turns back to idle.
      change_state(GameStates:States::IDLE)
    end

    super
    @una_check_tiks -= 1 unless idle? || @una_check_tiks <= 0
  end

  def change_state(state)
    super(state)
    if state == GameStates::States::ATTACKING
      @sprite.change_state(GameStates::States::CUSTOM)
    end
  end

  private
    def check_change_dir
      # This method changes the direction the wolf, (and therefore it's sprite) is facing in relation to the main char
      if (@hb.x - $WINDOW.player.hb.x) < 0
        change_dir( GameStates::FaceDir::RIGHT)
      else
        change_dir( GameStates::FaceDir::LEFT)
      end
    end
end
