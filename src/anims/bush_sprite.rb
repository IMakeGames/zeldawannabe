class BushSprite < Sprite

  def initialize
    change_state(GameStates::States::IDLE)
    init_anim_sprites
    @offset_x = -4
    @offset_y = -4
  end

  def change_state(state)
    @state = state
    case @state
      when GameStates::States::MOVING
        @total = 30
        @animation = @animated
      when GameStates::States::DYING
        @total = 15
        @animation = @dying
      when GameStates::States::IDLE
        return
    end

    @counter = 0
    @frame_duration = (@total/@animation.count).floor
    @frame_num = 1
  end

  def init_anim_sprites
    @imgs = Gosu::Image.load_tiles("../../assets/sprites/Mapas/bush3.png", 12, 12, retro: true)
    @fixed = @imgs[0]
    @animated = [@imgs[1],@imgs[0], @imgs[2]]
    @dying = [@imgs[3], @imgs[4], @imgs[5]]
  end

  def animate_linear(x, y, z)
    if idle?
      @fixed.draw_hitbox(x + @offset_x, y + @offset_y, z)
    else
      if @counter.between?(@frame_duration*(@frame_num - 1), @frame_duration*@frame_num)
        @img = @frame_num - 1 < @animation.count ? @animation[@frame_num -1] : @animation[@animation.count -1]
      else
        @frame_num += 1
      end
      @counter += 1

      @img.draw_hitbox(x + @offset_x, y + @offset_y, z)
    end
  end
end