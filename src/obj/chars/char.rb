require '../../src/obj/game_states'

class Char
  attr_accessor :state
  attr_accessor :face_dir

  def initialize
    @state =  GameStates::States::IDLE
    @face_dir = GameStates::FaceDir::DOWN
    @sprite = nil
  end

  def idle?
    return @state ==  GameStates::States::IDLE
  end

  def moving?
    return @state ==  GameStates::States::MOVING
  end

  def attacking?
    return @state ==  GameStates::States::ATTACKING
  end

  def recoiling?
    return @state ==  GameStates::States::RECOILING
  end

  def change_move_state(action)
    if action == GameStates::Action::PRESS && self.idle?
      puts "STATED MOVING"
      @state = GameStates::States::MOVING
    elsif action == GameStates::Action::RELEASE && self.moving?
      @state = GameStates::States::IDLE
    end
    @sprite.change_state(@state)
  end

  def change_dir(dir)
    @face_dir = dir
    @sprite.change_dir(dir)
  end
end