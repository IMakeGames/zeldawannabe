class SpittingPlantSprite < Sprite

  attr_accessor :attacking
  def initialize
    init_anim_sprites
    change_x(GameStates::FaceDir::LEFT)
    change_y(GameStates::FaceDir::DOWN)
    change_state(GameStates::States::IDLE)
    @counter = 0
    @recoil_counter = 0
    @offset_x = -5
    @offset_y = -5
  end

  def change_x(dir)
    if @h_dir != dir
      @h_dir = dir
      if @h_dir == GameStates::FaceDir::LEFT
        @x_scale = 1
        @reverse_offset_x = 0
      else
        @x_scale = -1
        @reverse_offset_x = 20
      end
      @animation = gime_right_anim
    end
  end

  def change_y(dir)
    if @v_dir != dir
      @v_dir = dir
      @animation = gime_right_anim
    end
  end

  def change_state(state)
    if @state != state
      @state = state
      case state
        when GameStates::States::IDLE
          @loop = true
          @total = 50
        when GameStates::States::ATTACKING
          @loop = false
          @total = 25
        when GameStates::States::RECOILING
          @recoil = true
          @recoil_counter = 18
        when GameStates::States::DYING
          @loop = false
          @total = 40
      end

      @counter = 0
      @animation = gime_right_anim
      @frame_duration = (@total/@animation.count).floor
      @total = (@frame_duration*@animation.count) < @total ? @frame_duration*@animation.count : @total
      @frame_num = 1

      #TODO: THIS CODE CAN HELP ANALIZING THE ANIMATIONS' TIME DURATION
      # if state == GameStates::States::RECOILING
      #   puts "anim count = "+@animation.count.to_s+" total duration = "+@total.to_s+" frame duration = "+ @frame_duration.to_s
      # end
    end
  end

  def animate_linear(x, y, z)
    if @counter.between?(@frame_duration*(@frame_num - 1), @frame_duration*@frame_num)
      @img = @frame_num - 1 < @animation.count ? @animation[@frame_num -1] : @animation[@animation.count -1]
    else
      @frame_num += 1
    end

    if @recoil_counter > 0 && @recoil_counter%2 == 0
      @img.draw(x + @offset_x + @reverse_offset_x, y + @offset_y, z, @x_scale, 1, Gosu::Color::RED)
    else
      @img.draw(x + @offset_x + @reverse_offset_x, y + @offset_y, z, @x_scale)
    end

    if @counter >= @total
      if @loop
        @counter = 0
        @frame_num = 1
      end
    end
    @recoil_counter = @recoil_counter > 0 ? @recoil_counter - 1 : 0
    @counter += 1
  end

  def init_anim_sprites
    @imgs = Gosu::Image.load_tiles("#{Dir.pwd}/assets/sprites/Enemies/badass plant_22x24.png", 22, 24, retro: true)
    @idle_down = [@imgs[0], @imgs[1], @imgs[0], @imgs[2]]
    @idle_up = [@imgs[6], @imgs[7], @imgs[6], @imgs[8]]
    @attacking_side = [@imgs[3], @imgs[4], @imgs[0]]
    @attacking_bot = [@imgs[3], @imgs[5], @imgs[0]]
    @attacking_top = [@imgs[9], @imgs[10], @imgs[6]]
    @recoiling = [@imgs[8], @imgs[9]]
    @dying = [@imgs[11], @imgs[12], @imgs[13]]
  end

  def gime_right_anim
    if idle?
      if @v_dir == GameStates::FaceDir::DOWN
        return @idle_down
      else
        return @idle_up
      end
    elsif attacking?
      if @attacking == :attacking_side
        return @attacking_side
      elsif @attacking == :attacking_down
        return @attacking_bot
      else
        return @attacking_top
      end
    elsif dying?
      return @dying
    else
      return @animation
    end
  end
end
