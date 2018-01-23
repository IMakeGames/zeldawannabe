module GameStates

  class States
    MOVING = 1
    IDLE = 2
    ATTACKING = 3
    RECOILING = 4
    SEATHING = 5
    ROLLING = 6
    DYING = 7
    CUSTOM = 8
    BLOCKING = 9
  end

  class FaceDir
    UP = 1
    RIGHT = 2
    DOWN = 3
    LEFT = 4

    def self.opposite_of(dir)
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
end