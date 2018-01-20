require '../anims/drop_sprite'
class HeartDrop < GameObject
  attr_reader :active
  def initialize(x,y)
    super(x+1,y+3,2,2)
    @sprite = DropSprite.new(self)
    change_state(GameStates::States::MOVING)
    @active = false
    @event_tiks = 30
  end

  def update
    @event_tiks -= 1
    if @event_tiks <= 0
      change_state(GameStates::States::IDLE)
      @active = true
    else
      @event_tiks -= 1
    end
  end
end