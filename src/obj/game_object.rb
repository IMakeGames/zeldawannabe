class GameObject
  attr_accessor :z_rendering, :hb, :id

  def initialize(x, y, w, h)
    @sprite = nil
    @hb = HitBox.new(x, y, w, h)
    @z_rendering = 1
  end

  def place(x, y)
    @hb.place(x, y)
  end

  def draw
    if $WINDOW.draw_hb
      @hb.draw
    end
    @sprite.animate_linear(@hb.x, @hb.y, @hb.y+@hb.h) unless @sprite == nil
  end

  def impacted

  end

  def change_state(id)
    @state = id
    @sprite.change_state(id) unless @sprite == nil
  end

  def idle?
    return @state == GameStates::States::IDLE
  end

  def moving?
    return @state == GameStates::States::MOVING
  end

  def attacking?
    return @state == GameStates::States::ATTACKING
  end

  def recoiling?
    return @state == GameStates::States::RECOILING
  end

  def dying?
    return @state == GameStates::States::DYING
  end

  def blocking?
    return @state == GameStates::States::BLOCKING
  end

  def die
    $WINDOW.current_map.remove_from_game(self)
  end
end