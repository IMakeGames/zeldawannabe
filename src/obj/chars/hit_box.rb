class HitBox
  attr_accessor :x, :y, :w, :h, :crs, :impact

  def initialize(x, y, w, h)
    @x = x
    @y = y
    @w = w
    @h = h
    @impact = false
  end

  def place(x, y)
    @x = x
    @y = y
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

  def check_point_collision(x,y)
    if x.between?(@x,@x+@w) && y.between?(@y,@y+@h)
      @impact = true
      return true
    end
    return false
  end

  def check_brute_collision(hb)

  end
end