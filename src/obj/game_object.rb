class GameObject
  attr_accessor :z_rendering, :hb, :sprite_offset_x, :sprite_offset_y, :id

  def initialize(x, y, w, h)
    @sprite = nil
    @hb = HitBox.new(x, y, w, h)
    @z_rendering = 1
  end

  def draw
    if $WINDOW.draw_hb
      @hb.draw
    end
    @sprite.animate_linear(@hb.x, @hb.y, @z_rendering) unless @sprite == nil
  end
end