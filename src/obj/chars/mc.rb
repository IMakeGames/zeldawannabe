require 'gosu'
require '../../src/obj/chars/char'
require '../anims/mc_sprite'
class Mc < Char
  CHAR_ACC = 0.2

  def initialize
    super(0,0,8,10)
    @sprite = McSprite.new
    @char_speed = 2
    @sah = []
    change_dir(GameStates::FaceDir::DOWN)
    #@sword_init_angle = @sia
    @sia = 0
  end

  def update
    if moving?
      move
    end
    if attacking?
      perform_attack
    end
  end

  def change_move_state(action)
    if action == GameStates::Action::PRESS && self.idle?
      @state = GameStates::States::MOVING
    elsif action == GameStates::Action::RELEASE && self.moving?
      @state = GameStates::States::IDLE
    end
    @sprite.change_state(@state)
  end

  def attack
    @state = GameStates::States::ATTACKING

    @action_tiks =18
    @fourf  = ((@action_tiks/5) * 4).ceil
    @threef = ((@action_tiks/5) * 3).ceil
    @twof   = ((@action_tiks/5) * 2).ceil
    @onef   = (@action_tiks/5).ceil
    @sprite.change_state(@state)
    #@sword_attack_hitboxes = @sah
    @sah = [HitBox.new(0,0,2,3), HitBox.new(0,0,2,3), HitBox.new(0,0,2,3)]

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
    if @action_tiks == @fourf ||  @action_tiks == @threef || @action_tiks == @twof || @action_tiks == @onef
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
    @sah.each do |hb|
      hb.draw
    end
  end

  def midpoint
    midpoint_x = (@hb.x + (@hb.w/2)).ceil
    midpoint_y = (@hb.y + (@hb.h/2)).ceil

    return [midpoint_x,midpoint_y]
  end

  def rotate_sword(angle)
    @sah[0].place(midpoint[0]+Gosu.offset_x(angle,8), midpoint[1]+Gosu.offset_y(angle,8))
    @sah[1].place(midpoint[0]+Gosu.offset_x(angle,11), midpoint[1]+Gosu.offset_y(angle,11))
    @sah[2].place(midpoint[0]+Gosu.offset_x(angle,14), midpoint[1]+Gosu.offset_y(angle,14))
  end
end