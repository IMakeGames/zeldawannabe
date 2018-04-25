require 'gosu'
require '../../src/obj/chars/char'
require '../anims/mc_sprite'
class Mc < Char
  attr_reader :unsheathed

  def initialize(x, y)
    super(x, y, 6, 8, true)
    @id = 1
    @sprite = McSprite.new
    @current_speed = 0
    @acc = 0.3
    @roll_acc = 0.5
    @decel = 0.4
    @recoil_ticks = 20
    @attack_dmg = 1
    @sah = []
    @total_hp = 12
    @current_hp = 12
    @recoil_magnitude = 8
    @until_next_attack = 0
    @until_next_roll = 0
    @until_next_sheath = 0
    #@sia means SWORD INITIAL ANGLE
    @sia = 0
    @unseathed = false
  end

  def update
    @face_dir == nil ? change_dir(GameStates::FaceDir::DOWN) : nil
    if !$WINDOW.kb_locked
      if $WINDOW.command_stack.empty?
        change_state(GameStates::States::IDLE)
      elsif !blocking? && $WINDOW.command_stack.last[0] == :MOVE
        change_dir($WINDOW.command_stack.last[1])
        change_state(GameStates::States::MOVING)
      elsif $WINDOW.command_stack.last[0] == :ATTACKORITEM
        if $WINDOW.command_stack.last[1] == :ATTACK && @until_next_attack <= 0
          $WINDOW.kb_locked = true
          attack
          @until_next_attack = 7
        else
          $WINDOW.command_stack.delete_if {|command| command[0] == :ATTACKORITEM}
        end
      elsif $WINDOW.command_stack.last[0] == :ROLLORBLOCK
        if $WINDOW.command_stack.last[1] == :ROLL && @until_next_roll <= 0
          $WINDOW.kb_locked = true
          @current_speed = 0
          change_state(GameStates::States::ROLLING)
          $WINDOW.command_stack.delete_if {|command| command[0] == :ROLLORBLOCK}
          @event_tiks = 25
          @until_next_roll = 15
        elsif $WINDOW.command_stack.last[1] == :BLOCK && !blocking?
          change_state(GameStates::States::BLOCKING)
        end
      elsif !blocking? && $WINDOW.command_stack.last[0] == :SHEATH && @until_next_sheath <= 0
        $WINDOW.kb_locked = true
        $WINDOW.command_stack.delete_if {|command| command[0] == :SHEATH}
        change_state(GameStates::States::SHEATHING)
        @unsheathed = !@unsheathed
        $WINDOW.interface.update
        @event_tiks =15
        @until_next_SHEATH = 15
      end
    else
      if attacking?
        perform_attack
      elsif recoiling? || (blocking? && @invis_frames > 0)
        recoil
      elsif rolling?
        roll
      end
      if dying?
        @event_tiks -= 1
        puts @event_tiks
      end
    end
    if moving?
      if @unsheathed
        @current_speed = @current_speed < 1.2 ? @current_speed + @acc : 1.2
      else
        @current_speed = @current_speed < 2 ? @current_speed + @acc : 2
      end
      move
    elsif !rolling?
      @current_speed = @current_speed > 0 ? @current_speed - @decel : 0
      move
    end

    if sheathing?
      @event_tiks -= 1
      if @event_tiks <= 0
        change_state(GameStates::States::IDLE)
        $WINDOW.kb_locked = false
      end
    end
    @invis_frames = @invis_frames > 0 ? @invis_frames - 1 : 0
    @until_next_roll = !rolling? && @until_next_roll > 0 ? @until_next_roll - 1 : @until_next_roll
    @until_next_attack = !attacking? && @until_next_attack > 0 ? @until_next_attack - 1 : @until_next_attack
    @until_next_sheath = !sheathing? && @until_next_sheath > 0 ? @until_next_sheath - 1 : @until_next_sheath

    $WINDOW.current_map.drops.each do |drop|
      if drop.idle? && drop.hb.check_brute_collision(@hb)
        drop.die
        drop_picked(drop.class)
      end
    end
    super
  end

  #TODO: BLOCKING MUST BE IMPLEMENTED
  def impacted(away_from, attack_dmg)
    if blocking?
      @current_hp = attack_dmg <=2 ? @current_hp : @current_hp - (attack_dmg/2).floor
      angle = Gosu.angle(away_from[0], away_from[1], @hb.x, @hb.y)
      @recoil_speed_x = Gosu.offset_x(angle, @recoil_magnitude)
      @recoil_speed_y = Gosu.offset_y(angle, @recoil_magnitude)
      @event_tiks = @current_hp > 0 ? 16 : 18
      @invis_frames =  16
    else
      if attacking?
        @sah.clear
        $WINDOW.command_stack.delete_if {|pair|
          pair[0] == :ATTACK
        }
      end
      super(away_from, attack_dmg)
      @invis_frames = 40
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

  def attack
    change_state(GameStates::States::ATTACKING)
    @event_tiks =11

    #@sword_attack_hitboxes = @sah
    @sah = [HitBox.new(0, 0, 2, 3), HitBox.new(0, 0, 2, 3)]

    case @face_dir
      when GameStates::FaceDir::UP
        @sia = 292.5
      when GameStates::FaceDir::RIGHT
        @sia = 22.5
      when GameStates::FaceDir::DOWN
        @sia = 112.5
      when GameStates::FaceDir::LEFT
        @sia = 202.5
    end
    rotate_sword(@sia)
  end

  def roll
    if @event_tiks.between?(21, 25)
      @current_speed += @roll_acc
    elsif @event_tiks == 20
      @invis_frames = 15
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

  def perform_attack
    @sia += 10
    rotate_sword(@sia)
    @sah.each do |hb|
      $WINDOW.current_map.enemies.each do |enemy|
        if !enemy.dying? && ((!enemy.recoiling? && !enemy.is_a?(Boar)) || (enemy.is_a?(Boar) && enemy.invis_frames <= 0)) && hb.check_brute_collision(enemy.hb)
          enemy.impacted(@hb.center, @attack_dmg)
        end
      end
      $WINDOW.current_map.bushes.each do |bush|
        if hb.check_brute_collision(bush.hb)
          bush.impacted
        end
      end
    end

    if @event_tiks == 0
      change_state(GameStates::States::IDLE)
      @sah.clear
      $WINDOW.command_stack.delete_if {|pair|
        pair[0] == :ATTACK
      }
      $WINDOW.kb_locked = false
    end
    @event_tiks -= 1
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

  def rotate_sword(angle)
    mid_point_adjusted_y = @hb.center[1]
    mid_point_adjusted_x = @hb.center[0]
    case @face_dir
      when GameStates::FaceDir::DOWN
        mid_point_adjusted_y -= 2
      when GameStates::FaceDir::LEFT
        mid_point_adjusted_x -= 3
      when GameStates::FaceDir::UP
        mid_point_adjusted_y -= 3
    end
    @sah[0].place(mid_point_adjusted_x+Gosu.offset_x(angle, 8), mid_point_adjusted_y+Gosu.offset_y(angle, 8))

    @sah[1].place(mid_point_adjusted_x+Gosu.offset_x(angle, 13), mid_point_adjusted_y+Gosu.offset_y(angle, 14))
  end

  def dead?
    return dying? && @event_tiks <= 0
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
end