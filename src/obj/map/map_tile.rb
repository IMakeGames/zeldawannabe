class MapTile
  attr_accessor :x, :y, :w, :h, :impact

  def initialize(x, y, w, h, solid)
    @x = x
    @y = y
    @w = w
    @h = h
    @solid = solid
    @impact = false
    @hb_z = 2
  end

  def draw
    if @impact
      draw_with = $WINDOW.color_yellow
      @impact = false
      @hb_z = 3
    else
      draw_with = $WINDOW.color_red
      @hb_z = 2
    end
    Gosu.draw_line(@x, @y, draw_with, @x + @w, @y, draw_with, @hb_z)
    Gosu.draw_line(@x + @w, @y, draw_with, @x + @w, @y + @h, draw_with, @hb_z)
    Gosu.draw_line(@x + @w, @y + @h, draw_with, @x, @y + @h, draw_with, @hb_z)
    Gosu.draw_line(@x, @y + @h, draw_with, @x, @y, draw_with, @hb_z)
  end

  def solid?
    return @solid
  end
end