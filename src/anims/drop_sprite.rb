
class DropSprite < Sprite
  def initialize(type)
    @imgs = Gosu::Image.load_tiles("../../assets/sprites/Mapas/droppables_9x9.png", 12, 12, retro: true)
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
      @sprite.draw(x-3, y-4, z)
    end
  end
end