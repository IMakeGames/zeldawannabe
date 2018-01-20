require '../anims/drop_sprite'
class HeartDrop < GameObject
  attr_reader :active
  def initialize(x,y)
    super(x+1,y+2,4,4)
    @sprite = DropSprite.new(self)
    change_state(GameStates::States::MOVING)
    @event_tiks = 30
  end

  def update
    @event_tiks -= 1
    if @event_tiks <= 0
      change_state(GameStates::States::IDLE)
    else
      @event_tiks -= 1
    end
  end
end