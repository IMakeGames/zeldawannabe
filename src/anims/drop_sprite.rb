
class DropSprite < Sprite
  def initialize(type)
    @imgs = Gosu::Image.load_tiles("../../assets/sprites/Mapas/droppables_9x9.png", 9, 9, retro: true)
    @shadow = @imgs[1]
    if type.is_a?(HeartDrop)
      @sprite = @imgs[0]
    end
    @y_vel = -4
    @y_pos = nil
    @y_acc = 0.5
  end

  def animate_linear(x, y, z)
    if @y_pos == nil
      @y_pos = y
    end
    if moving?
      @y_pos += @y_vel
      @y_vel += @y_acc
      @sprite.draw(x-3, @y_pos, z)
    else
      @sprite.draw(x-3, y-5, z)
    end
    @shadow.draw(x-3,y-5,z-1)
  end
end