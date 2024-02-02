class BatSprite < Sprite

  def initialize
    init_anim_sprites
    @counter = 0
    @offset_x = -9
    @offset_y = -3
    @loop = true
  end

  def change_state(state)
    if @state != state
      @state = state
      if idle?
        @img = gime_right_anim
      else
        case state
          when GameStates::States::WALKING
            @loop = true
            @total = 30
          when GameStates::States::ATTACKING
            @loop = true
            @total = 10
          when GameStates::States::RECOILING
            @loop = true
            @total = 6
          when GameStates::States::DYING
            @loop = false
            @total = 30
        end

        @counter = 0
        @animation = gime_right_anim
        @frame_duration = (@total/@animation.count).floor
        @total = (@frame_duration*@animation.count) < @total ? @frame_duration*@animation.count : @total
        @frame_num = 1
      end
      #TODO: THIS CODE CAN HELP ANALIZING THE ANIMATIONS' TIME DURATION
      # if state == GameStates::States::DYING
      #   puts "anim count = "+@animation.count.to_s+" total duration = "+@total.to_s+" frame duration = "+ @frame_duration.to_s
      # end
    end
  end

  def animate_linear(x, y, z)
    if idle?
      @img.draw(x + @offset_x, y + @offset_y, z)
    else
      if @counter.between?(@frame_duration*(@frame_num - 1), @frame_duration*@frame_num)
        @img = @frame_num - 1 < @animation.count ? @animation[@frame_num -1] : @animation[@animation.count -1]
      else
        @frame_num += 1
      end
      @counter += 1

      @img.draw(x + @offset_x, y + @offset_y, z)

      if @counter >= @total
        if @loop
          @counter = 0
          @frame_num = 1
        end
      end
    end
  end

  def init_anim_sprites
    @imgs = Gosu::Image.load_tiles("#{Dir.pwd}/assets/sprites/Enemies/bat_21x9.png", 21, 9, retro: true)
    @idle = @imgs[2]
    @moving = [@imgs[0], @imgs[1], @imgs[2]]
    @recoiling = [@imgs[5], @imgs[8]]
    @dying = [@imgs[3], @imgs[4], @imgs[6], @imgs[7]]
  end

  def gime_right_anim
    if moving?
      return @moving
    elsif recoiling?
      return @recoiling
    elsif attacking?
      return @moving
    elsif dying?
      return @dying
    elsif idle?
      return @idle
    end
  end
end
