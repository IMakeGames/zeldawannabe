class PoisonPuffSprite < Sprite

  def initialize
    init_anim_sprites
    @offset_x = 0
    @offset_y = -5
    @counter = 0
    @total = 25
    @frame_duration = (@total/@animation.count).floor
    @total = (@frame_duration*@animation.count) < @total ? @frame_duration*@animation.count : @total
    @frame_num = 1
  end

  def animate_linear(x, y, z)
    if @counter.between?(@frame_duration*(@frame_num - 1), @frame_duration*@frame_num)
      @img = @frame_num - 1 < @animation.count ? @animation[@frame_num -1] : @animation[@animation.count -1]
    else
      @frame_num += 1
    end

    @img.draw_hitbox(x + @offset_x, y + @offset_y, z)
    @shadow.draw_hitbox(x+@offset_x, y + @offset_y + 7, z)

    if @counter >= @total
      @counter = 0
      @frame_num = 1
    end
    @counter += 1
  end

  def init_anim_sprites
    @imgs = Gosu::Image.load_tiles("../../assets/sprites/Enemies/projectiles_9x9.png", 9, 9, retro: true)
    @animation = [@imgs[0], @imgs[1], @imgs[2], @imgs[3]]
    @shadow = @imgs[4]
  end
end