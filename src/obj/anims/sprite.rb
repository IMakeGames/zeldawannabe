class Sprite
  attr_accessor :face_dir
  def idle?
    return @state ==  GameStates::States::IDLE
  end

  def moving?
    return @state ==  GameStates::States::WALKING
  end

  def attacking?
    return @state ==  GameStates::States::ATTACKING
  end

  def recoiling?
    return @state ==  GameStates::States::RECOILING
  end

  def dying?
    return @state == GameStates::States::DYING
  end

  def animate_linear(x,y,z)
    raise "MUST BE OVERRIDEN"
  end

  def change_state(state)
    @state = state
  end

end