module GameStates

  class States
    MOVING = 1
    IDLE = 2
    ATTACKING = 3
    RECOILING = 4
  end

  class FaceDir
    UP = 1
    RIGHT = 2
    DOWN = 3
    LEFT = 4

    def self.oposite_of(dir)
      case dir
        when UP
          return DOWN
        when RIGHT
          return LEFT
        when DOWN
          return UP
        when LEFT
          return RIGHT
      end
    end
  end

  class Action
    PRESS = 1
    RELEASE = 1
  end
end