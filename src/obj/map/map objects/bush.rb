require_relative'../../anims/bush_sprite'
require_relative'../../map/droppables/heart_drop'
class Bush < GameObject
  MOVEMENT_PERCENTAGE = 20

  def initialize(x, y)
    super(x+4, y+4, 5, 5)
    @sprite = BushSprite.new
    change_state(GameStates::States::IDLE)
    @until_next_movement_check = 100
  end

  def impacted
    change_state(GameStates::States::DYING)
    @event_tiks = 15
  end

  def update
    if idle?
      if @until_next_movement_check <= 0
        #dieroll = Gosu.random(1, 101)
        dieroll =  Random.rand(100)
        if dieroll <= MOVEMENT_PERCENTAGE
          change_state(GameStates::States::WALKING)
          @event_tiks =30
        else
          @until_next_movement_check = 75
        end
      else
        @until_next_movement_check -= 1
      end
    elsif !idle?
      if @event_tiks <= 0
        change_state(GameStates::States::IDLE)
        @until_next_movement_check = 100
      end
      @event_tiks -= 1
    elsif dying?
      if @event_tiks <= 0
        dieroll = Random.rand(100)
        puts "dieroll: #{dieroll}"
        if dieroll < 10
          $WINDOW.current_map.drops << HeartDrop.new(@hb.x,@hb.y)
        end
        die
      end
      @event_tiks -= 1
    end
  end
end
