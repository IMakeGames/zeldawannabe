require 'gosu'
require '../../src/obj/chars/char'
require '../anims/mc_sprite'
class Mc < Char
  attr_reader :invis_frames

  def initialize(x, y)
    super(x, y, 6, 8)
    @id = 1
    @sprite = McSprite.new
    @char_speed = 1.8
    @recoil_ticks = 20
    @attack_dmg = 1
    @sah = []
    @total_hp = 12
    @current_hp = 12
    change_dir(GameStates::FaceDir::DOWN)
    change_state(GameStates::States::IDLE)

    #@sword_initial_angle = @sia
    @sia = 0
    @invis_frames = 0
  end

  def update
    if !$WINDOW.kb_locked
      if $WINDOW.command_stack.empty?
        change_state(GameStates::States::IDLE)
      elsif $WINDOW.command_stack.last.keys.first == :MOVE
        change_dir($WINDOW.command_stack.last[:MOVE])
        change_state(GameStates::States::MOVING)
      elsif $WINDOW.command_stack.last.keys.first == :ATTACK
        $WINDOW.kb_locked = true
        attack
      end
      if moving?
        move
      end
    else
      if attacking?
        perform_attack
      end
      if recoiling?
        recoil
      end
      if dying?
        @event_tiks -= 1
        puts @event_tiks
      end
    end
    @invis_frames = @invis_frames > 0 ? @invis_frames - 1 : 0
  end

  def impacted(away_from, attack_dmg)
    if @state == GameStates::States::ATTACKING
      @sah = []
      $WINDOW.command_stack.delete_if {|hash|
        hash.keys.last == :ATTACK
      }
    end
    super(away_from, attack_dmg)
    $WINDOW.kb_locked = true
    @invis_frames = 40
    $WINDOW.interface.update
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
    @event_tiks =13

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

  def perform_attack
    @sia += 9
    rotate_sword(@sia)
    @sah.each do |hb|
      $WINDOW.current_map.enemies.each do |enemy|
        if !enemy.dying? && !enemy.recoiling? && hb.check_brute_collision(enemy.hb)
          enemy.impacted(@hb.midpoint, @attack_dmg)
        end
      end
    end

    if @event_tiks == 0
      change_state(GameStates::States::IDLE)
      @sah = []
      $WINDOW.command_stack.delete_if {|hash|
        hash.keys.last == :ATTACK
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
    mid_point_adjusted = @hb.midpoint[1]
    case @face_dir
      when GameStates::FaceDir::DOWN
        mid_point_adjusted -= 3
    end
    @sah[0].place(@hb.midpoint[0]+Gosu.offset_x(angle, 10), mid_point_adjusted+Gosu.offset_y(angle, 10))

    @sah[1].place(@hb.midpoint[0]+Gosu.offset_x(angle, 13), mid_point_adjusted+Gosu.offset_y(angle, 14))
  end

  def dead?
    return dying? && @event_tiks <= 0
  end
end