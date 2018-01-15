class Sprite

  def initialize
    @state =  GameStates::States::IDLE
    @face_dir = GameStates::FaceDir::LEFT
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
  
end