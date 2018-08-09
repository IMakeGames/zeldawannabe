# Main Character Class Class.
# Inherits from Char Class
# Introduces new attributes and instantiates others
# Class Attributes:
#  *acc: determines the acceleration the main character has.
#  *sah: Sword attack hitboxes, an array of hitboxes that compose a sword attack.
#  *una_tiks: Until Next Attack Tiks, counter that determines time before the next attack can be performed.
#  *unr_tiks: Until Next Roll Tiks, counter that determines time before the next roll can be performed.
#  *uns_frames: Unitl Next Sheathe Tiks, counter that determines time before next sheath/unsheathe can be performed
#  *sia: Sword Initial Angle, angle in degrees of the initial sword attack.
#  *unseathed: boolean attribute that determines whether the main character is in an unsheathed state or not.
#  *command_stack: Storage for inputed keys and actions.
#  *changed_command_stack: Indicates whether command_stack has been changed for taking action

require 'gosu'
require_relative 'sword_object'
require '../../src/obj/chars/char'
require '../anims/mc_sprite'
class MainChar < Char
  attr_accessor :changed_command_stack
  attr_reader :unsheathed, :current_speed, :sah, :una_tiks, :unr_tiks, :uns_tiks, :sia, :command_stack

  def initialize(x, y)
    super(x, y, 6, 8, true)
    @id = 1                                          # Main Char id should always be 1
    @sprite = McSprite.new                           # Sprite is Main Char Sprite, DUH
    @recoil_frames = 20                              # Total framing time-span = 20
    @attack_dmg = 1                                  # SWORD attack_dmg actually. TODO: MAKE ITEM/ATTACK DEPENDANT RATHER THAN FIXED
    @command_stack = []                              # COMMAND STACK stores the inputed commands that must be performed
    @changed_command_stack = false                   # COMMAND STACK starts unchanged.
    @sah = []                                        # Sword attack hitboces starts empty
    @sword = nil
    @total_hp = @current_hp = 12                     # HP setup by default
    @recoil_magnitude = 8                            # RECOIL MAGNITUDE starts at 8. TODO: MAKE DYNAMIC
    @una_tiks = @unr_tiks = @uns_tiks = 0            # All counters start at 0
    @sia = 0                                         # SWORD angle starts at 0
    @unsheathed = false                              # Main Char is not unsheathed at start
    change_dir(GameStates::FaceDir::DOWN)            # Sets up direction and state for this char and animation
    change_state(GameStates::States::IDLE)           # ^^
  end

  # Main update Method. Overrides parent update method.
  def update

    if @changed_command_stack && @event_tiks <= 0
      #================================== WHEN COMMAND HAS CHANGED AND NO EVENTS ======================================
      # If command_stack has changed, eg. if a button has been pressed or released, then enters in this condition
      if @command_stack.last == nil
        # If command_stack is empty, then there is no input that must be accounted for
        @vect_acc = -0.3
        @max_v = 0
        change_state(GameStates::States::IDLE)
      else
        if @command_stack.last[0] == :WALK
          # If command_stack's last entry is a walking entry, then walking pattern is set.
          set_walking_pattern
        elsif @command_stack.last[0] == :SHEATHE_ACTION
          # If command_stack's last entry is a sheathe action entry, then sheathing action is called.
          set_sheathe_action
        elsif @command_stack.last[0] == :ATTACKORITEM
          # If command_stack's last entry is a attack action entry, then attack action is called.
          set_attacking_action
        end
      end
      # Once command_stack's latest entry has been performed, changed_command_stack flag is set to false.
      @changed_command_stack = false

    elsif @event_tiks > 0 && @event_tiks -1 <= 0
      #================================== WHEN EVENT HAS ENDED ======================================
      # If event tiks reaches 0 this update, change from last action
      if sheathing?
        # If sheathing or unsheathing, action is taken from command_stack, uns_tiks is set to 15 and keyboard is
        # unlocked
        @uns_tiks = 15
        $WINDOW.kb_locked = false
      end

      if attacking?
        # If sheathing or unsheathing, action is taken from command_stack, uns_tiks is set to 15 and keyboard is
        # unlocked
        @una_tiks = 7
        @sword = nil
        $WINDOW.kb_locked = false
      end
    end

    # if !$WINDOW.kb_locked
    #   if $WINDOW.command_stack.empty?
    #     change_state(GameStates::States::IDLE)
    #   elsif !blocking? && $WINDOW.command_stack.last[0] == :MOVE
    #     change_dir($WINDOW.command_stack.last[1])
    #     change_state(GameStates::States::MOVING)
    #   elsif $WINDOW.command_stack.last[0] == :ATTACKORITEM
    #     if $WINDOW.command_stack.last[1] == :ATTACK && @una_tiks <= 0
    #       $WINDOW.kb_locked = true
    #       attack
    #       @una_tiks = 7
    #     else
    #       $WINDOW.command_stack.delete_if {|command| command[0] == :ATTACKORITEM}
    #     end
    #   elsif $WINDOW.command_stack.last[0] == :ROLLORBLOCK
    #     if $WINDOW.command_stack.last[1] == :ROLL && @unr_tiks <= 0
    #       $WINDOW.kb_locked = true
    #       @current_speed = 0
    #       change_state(GameStates::States::ROLLING)
    #       $WINDOW.command_stack.delete_if {|command| command[0] == :ROLLORBLOCK}
    #       @event_tiks = 25
    #       @unr_tiks = 15
    #     elsif $WINDOW.command_stack.last[1] == :BLOCK && !blocking?
    #       change_state(GameStates::States::BLOCKING)
    #     end
    #   elsif !blocking? && $WINDOW.command_stack.last[0] == :SHEATH && @uns_tiks <= 0
    #     $WINDOW.kb_locked = true
    #     $WINDOW.command_stack.delete_if {|command| command[0] == :SHEATH}
    #     change_state(GameStates::States::SHEATHING)
    #     @unsheathed = !@unsheathed
    #     $WINDOW.interface.update
    #     @event_tiks =15
    #     @until_next_SHEATH = 15
    #   end
    # else
    #   if attacking?
    #     perform_attack
    #   elsif recoiling? || (blocking? && @inv_frames > 0)
    #     recoil
    #   elsif rolling?
    #     roll
    #   end
    #   if dying?
    #     @event_tiks -= 1
    #     puts @event_tiks
    #   end
    # end
    # if moving?
    #   if @unsheathed
    #     @current_speed = @current_speed < 1.2 ? @current_speed + @acc : 1.2
    #   else
    #     @current_speed = @current_speed < 2 ? @current_speed + @acc : 2
    #   end
    #   move
    # elsif !rolling?
    #   @current_speed = @current_speed > 0 ? @current_speed - @decel : 0
    #   move
    # end
    #
    # if sheathing?
    #   @event_tiks -= 1
    #   if @event_tiks <= 0
    #     change_state(GameStates::States::IDLE)
    #     $WINDOW.kb_locked = false
    #   end
    # end
    # @inv_frames = @inv_frames > 0 ? @inv_frames - 1 : 0
    # @unr_tiks = !rolling? && @unr_tiks > 0 ? @unr_tiks - 1 : @unr_tiks
    # @una_tiks = !attacking? && @una_tiks > 0 ? @una_tiks - 1 : @una_tiks
    # @uns_tiks = !sheathing? && @uns_tiks > 0 ? @uns_tiks - 1 : @uns_tiks
    #
    # $WINDOW.current_map.drops.each do |drop|
    #   if drop.idle? && drop.hb.check_brute_collision(@hb)
    #     drop.die
    #     drop_picked(drop.class)
    #   end
    # end

    super

    #============================== REST OFF TIKS AND CLEAN UP
    @sword.update unless @sword.nil?
    @uns_tiks -= 1 unless @uns_tiks <= 0
    @una_tiks -= 1 unless @una_tiks <= 0
  end

  #TODO: BLOCKING MUST BE IMPLEMENTED
  def impacted(away_from, attack_dmg)
    if blocking?
      @current_hp = attack_dmg <=2 ? @current_hp : @current_hp - (attack_dmg/2).floor
      angle = Gosu.angle(away_from[0], away_from[1], @hb.x, @hb.y)
      @recoil_speed_x = Gosu.offset_x(angle, @recoil_magnitude)
      @recoil_speed_y = Gosu.offset_y(angle, @recoil_magnitude)
      @event_tiks = @current_hp > 0 ? 16 : 18
      @inv_frames =  16
    else
      if attacking?
        @sah.clear
        $WINDOW.command_stack.delete_if {|pair|
          pair[0] == :ATTACK
        }
      end
      super(away_from, attack_dmg)
      @inv_frames = 40
    end
    $WINDOW.kb_locked = true
    $WINDOW.interface.update
    puts "PLAYER'S HP = #{@current_hp}"
  end

  def recoil
    super
    if @event_tiks <= 0 && @current_hp > 0
      $WINDOW.kb_locked = false
    end
    if @current_hp <= 0 && dying?
      @event_tiks = 61
    end
    if @event_tiks%2 > 0
      $WINDOW.interface.next_print_red
    end
  end

  def roll
    if @event_tiks.between?(21, 25)
      @current_speed += @roll_acc
    elsif @event_tiks == 20
      @inv_frames = 15
    elsif @event_tiks.between?(0, 4)
      @current_speed -= @roll_acc
    end
    move
    @event_tiks -= 1
    if @event_tiks <= 0
      change_state(GameStates::States::IDLE)
      $WINDOW.kb_locked = false
    end
  end

  def draw
    if dead?
      @sprite.draw_dead(@hb.x, @hb.y, @z_rendering)
    else
      super
      if $WINDOW.draw_hb
        @sah.each do |hb|
          hb.draw
        end
      end
    end
  end

  def drop_picked(type)
    if type == HeartDrop
      @current_hp = @current_hp + 4 >= @total_hp ? @total_hp : @current_hp + 4
      $WINDOW.interface.update
    end
  end

  def rolling?
    return @state == GameStates::States::ROLLING
  end

  def sheathing?
    return @state == GameStates::States::SHEATHING
  end

  private

    # Method that sets sheathe action.
    def set_sheathe_action
      # Char is stopped.
      # KEYBOARD is locked
      # Event Tiks is set to 15
      # state is changed to sheathing
      # unsheathed state is set to opposite of what it was.
      # animation is also set to that.
      # interface is updated.
      @vect_acc = -0.3
      @max_v = 0
      $WINDOW.kb_locked = true
      @event_tiks =15
      change_state(GameStates::States::SHEATHING)
      @unsheathed = !@unsheathed
      @sprite.unsheathed_state = @unsheathed
      $WINDOW.interface.update
      @command_stack.delete_if {|pair|
        pair[0] == :SHEATHE_ACTION
      }
    end

    #Method that sets attacking action. See set_sheathe_action for reference
    def set_attacking_action
      @vect_acc = -0.3
      @max_v = 0
      $WINDOW.kb_locked = true
      @event_tiks =11
      change_state(GameStates::States::ATTACKING)
      @sword = SwordObject.new(@face_dir, @hb)
      @command_stack.delete_if {|pair|
        pair[0] == :ATTACKORITEM
      }
    end

    # Method that sets walking pattern taking into consideration the content of command_stack
    # TODO: Must fix walking backwards
    def set_walking_pattern
      # First, another walking command is searched for in command stack
      another_walking_command = nil
      @command_stack.reverse_each do |command|
        if command != @command_stack.last && command[0] == :WALK
          another_walking_command = command

          break
        end
      end
      if another_walking_command.nil?
        # If there are no other walking commands in command stack, it is assumed that the walking pattern is straight
        @vect_acc = 0.3
        @max_v = 2
        case(@command_stack.last[1])
          when GameStates::FaceDir::LEFT
            @vect_angle = 270
          when GameStates::FaceDir::RIGHT
            @vect_angle = 90
          when GameStates::FaceDir::UP
            @vect_angle = 0
          when GameStates::FaceDir::DOWN
            @vect_angle = 180
        end
        change_dir(@command_stack.last[1])
        change_state(GameStates::States::WALKING)
      else
        # Else, the last walking command is taken into account.
        case(@command_stack.last[1])
          when GameStates::FaceDir::LEFT
            case (another_walking_command[1])
              when GameStates::FaceDir::RIGHT
                @vect_acc = -0.3
                @max_v = 0
                change_state(GameStates::States::IDLE)
              when GameStates::FaceDir::UP
                @vect_angle = 315
                @max_v = 2.5
              when GameStates::FaceDir::DOWN
                @vect_angle = 225
                @max_v = 2.5
            end
          when GameStates::FaceDir::RIGHT
            case (another_walking_command[1])
              when GameStates::FaceDir::LEFT
                @vect_acc = -0.3
                @max_v = 0
                change_state(GameStates::States::IDLE)
              when GameStates::FaceDir::UP
                @vect_angle = 45
                @max_v = 2.5
              when GameStates::FaceDir::DOWN
                @vect_angle = 135
                @max_v = 2.5
            end
          when GameStates::FaceDir::UP
            case (another_walking_command[1])
              when GameStates::FaceDir::DOWN
                @vect_acc = -0.3
                @max_v = 0
                change_state(GameStates::States::IDLE)
              when GameStates::FaceDir::LEFT
                @vect_angle = 315
                @max_v = 2.5
              when GameStates::FaceDir::RIGHT
                @vect_angle = 45
                @max_v = 2.5
            end
          when GameStates::FaceDir::DOWN
            case (another_walking_command[1])
              when GameStates::FaceDir::UP
                @vect_acc = -0.3
                @max_v = 0
                change_state(GameStates::States::IDLE)
              when GameStates::FaceDir::LEFT
                @vect_angle = 225
                @max_v = 2.5
              when GameStates::FaceDir::RIGHT
                @vect_angle = 135
                @max_v = 2.5
            end
        end
      end
    end
end