require 'gosu'
require '../../src/obj/chars/char'
require '../anims/mc_sprite'
class Mc < Char
  CHAR_ACC = 0.2

  def initialize
    super(0, 0, 8, 10)
    @sprite = McSprite.new
    @char_speed = 2
    @sah = []
    change_dir(GameStates::FaceDir::DOWN)
    change_state(GameStates::States::IDLE)
    #@sword_init_angle = @sia
    @sia = 0
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
    end
  end

  def attack
    @state = GameStates::States::ATTACKING

    @action_tiks =0.3*$WINDOW.fps
    @fourf = ((@action_tiks/5) * 4).ceil
    @threef = ((@action_tiks/5) * 3).ceil
    @twof = ((@action_tiks/5) * 2).ceil
    @onef = (@action_tiks/5).ceil
    @sprite.change_state(@state)
    #@sword_attack_hitboxes = @sah
    @sah = [HitBox.new(0, 0, 2, 3), HitBox.new(0, 0, 2, 3), HitBox.new(0, 0, 2, 3)]

    case @face_dir
      when GameStates::FaceDir::UP
        @sia = 292.5
      when GameStates::FaceDir::RIGHT
        @sia = 67.5
      when GameStates::FaceDir::DOWN
        @sia = 112.5
      when GameStates::FaceDir::LEFT
        @sia = 202.5
    end
    rotate_sword(@sia)
  end

  def perform_attack
    if @action_tiks == @fourf || @action_tiks == @threef || @action_tiks == @twof || @action_tiks == @onef
      @sia += 22.5
      rotate_sword(@sia)
    elsif @action_tiks == 0
      @sah = []
      @state = GameStates::States::IDLE
      @sprite.change_state(@state)
      $WINDOW.kb_locked = false
    end
    @action_tiks -= 1
  end

  def draw
    super
    if $WINDOW.draw_hb
      @sah.each do |hb|
        hb.draw
      end
    end

  end

  def midpoint
    midpoint_x = (@hb.x + (@hb.w/2)).ceil
    midpoint_y = (@hb.y + (@hb.h/2)).ceil

    return [midpoint_x, midpoint_y]
  end

  def rotate_sword(angle)
    @sah[0].place(midpoint[0]+Gosu.offset_x(angle, 10), midpoint[1]+Gosu.offset_y(angle, 10))
    @sah[1].place(midpoint[0]+Gosu.offset_x(angle, 12), midpoint[1]+Gosu.offset_y(angle, 13))
    @sah[2].place(midpoint[0]+Gosu.offset_x(angle, 14), midpoint[1]+Gosu.offset_y(angle, 16))
  end
end