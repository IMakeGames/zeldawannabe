class MapTile
  attr_accessor :x,:y,:w,:h,:img

  def initialize(sprite, x, y)
    @img = sprite
    @x = x
    @y = y
  end

  def draw
    @img.draw(@x, @y, 1)
  end
end