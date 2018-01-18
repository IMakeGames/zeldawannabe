require 'gosu'
require '../../src/obj/chars/char'
require '../anims/mc_sprite'
class Mc < Char
  attr_reader :invis_frames
  CHAR_ACC = 0.2

  def initialize(x, y)
    super(x, y, 8, 10)
    @sprite = McSprite.new
    @char_speed = 2
    @sah = []
    @hp = 10
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
    end
    @invis_frames = @invis_frames > 0 ? @invis_frames - 1 : 0
  end

  def impacted(away_from)
    super(away_from)
    $WINDOW.kb_locked = true
    @invis_frames = 40
  end

  def recoil
    super
    if @event_tiks <= 0
      $WINDOW.kb_locked = false
    end
  end

  def attack
    change_state(GameStates::States::ATTACKING)
    @event_tiks =0.3*$WINDOW.fps

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
    @sia += 8
    rotate_sword(@sia)
    @sah.each do |hb|
      $WINDOW.current_map.enemies.each do |enemy|
        if !enemy.recoiling? && hb.check_brute_collision(enemy.hb)
          enemy.impacted(@hb.midpoint)
        end
      end
    end

    if @event_tiks == 0
      @sah = []
      change_state(GameStates::States::IDLE)
      $WINDOW.command_stack.delete_if {|hash|
        hash.keys.last == :ATTACK
      }
      $WINDOW.kb_locked = false
    end
    @event_tiks -= 1
  end

  def draw
    super
    if $WINDOW.draw_hb
      @sah.each do |hb|
        hb.draw
      end
    end

  end

  def rotate_sword(angle)
    @sah[0].place(@hb.midpoint[0]+Gosu.offset_x(angle, 10), @hb.midpoint[1]+Gosu.offset_y(angle, 10))

    @sah[1].place(@hb.midpoint[0]+Gosu.offset_x(angle, 14), @hb.midpoint[1]+Gosu.offset_y(angle, 16))
  end
end