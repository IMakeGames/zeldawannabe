class HitBox
  attr_accessor :x, :y, :w, :h, :impact

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
      draw_with = Gosu::Color::YELLOW
      @impact = false
      @hb_z = 3
    else
      draw_with = Gosu::Color::RED
      @hb_z = 2
    end
    Gosu.draw_line(@x, @y, draw_with, @x + @w, @y, draw_with, @hb_z)
    Gosu.draw_line(@x + @w, @y, draw_with, @x + @w, @y + @h, draw_with, @hb_z)
    Gosu.draw_line(@x + @w, @y + @h, draw_with, @x, @y + @h, draw_with, @hb_z)
    Gosu.draw_line(@x, @y + @h, draw_with, @x, @y, draw_with, @hb_z)
  end

  def check_point_collision(x, y)
    if x.between?(@x, @x+@w) && y.between?(@y, @y+@h)
      @impact = true
      return true
    end
    return false
  end

  def check_brute_collision(hb)
    if hb.x < @x+@w && hb.x+hb.w > @x && hb.y < @y+@h && hb.y+hb.h > @y
      @impact = true
      return true
    end
    return false
  end

  def midpoint
    midpoint_x = (@x + (@w/2)).ceil
    midpoint_y = (@y + (@h/2)).ceil

    return [midpoint_x, midpoint_y]
  end
end