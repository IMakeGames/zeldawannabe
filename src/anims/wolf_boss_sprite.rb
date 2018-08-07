class WolfBossSprite < Sprite
  WALKING_ANIM_DURATION = 0.7

  def initialize
    init_anim_sprites
    change_dir(GameStates::FaceDir::LEFT)
    change_state(GameStates::States::IDLE)
    @counter = 0
    @offset_x = -20
    @offset_y = -10
  end

  def change_dir(dir)
    if @face_dir != dir
      @face_dir = dir
      if @face_dir == GameStates::FaceDir::LEFT
        @x_scale = 1
        @reverse_offset_x = 0
      else
        @x_scale = -1
        @reverse_offset_x = 60
      end
      @animation = gime_right_anim
    end
  end

  def change_state(state)
    if @state != state
      @state = state
      case state
        when GameStates::States::MOVING || :approaching
          @loop = true
          @total = 35
        when GameStates::States::IDLE
          @loop = true
          @total = 70
        when GameStates::States::ATTACKING
          @loop = false
          @total = 40
        when GameStates::States::RECOILING
          @loop = true
          @total = 6
        when GameStates::States::DYING
          @loop = false
          @total = 20
        when :howling
          @total = 70
          @index = 0
          @img_pair = @howling_anim[@index]
          @counter = 0
          return
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
    if howling?
      animate_howl(x,y,z)
    elsif attacking?
      animate_attack(x, y, z)
    else
      if @counter.between?(@frame_duration*(@frame_num - 1), @frame_duration*@frame_num)
        @img = @frame_num - 1 < @animation.count ? @animation[@frame_num -1] : @animation[@animation.count -1]
      else
        @frame_num += 1
      end

      @img.draw_hitbox(x + @offset_x + @reverse_offset_x, y + @offset_y, z, @x_scale)

      if @counter >= @total
        if @loop
          @counter = 0
          @frame_num = 1
          if idle?
            # change_dir(GameStates::FaceDir.opposite_of(@face_dir))
          end
        end
      end
    end
    @counter += 1
  end

  def animate_howl(x, y, z)
    if @counter >= @total*@img_pair[1]
      @index += 1
      @img_pair = @howling_anim[@index]
      @counter = 0
    end

    howling_offset = @counter%2 == 0 && @index == 3 ? 1 : 0

    @img_pair[0].draw_hitbox(x + @offset_x + @reverse_offset_x + howling_offset, y + @offset_y, z, @x_scale)
  end

  def animate_attack(x,y,z)
    if @counter < 20
      @animation[0].draw_hitbox(x + @offset_x + @reverse_offset_x, y + @offset_y, z, @x_scale)
    elsif @counter.between?(21,27)
      @animation[1].draw_hitbox(x + @offset_x + @reverse_offset_x, y + @offset_y, z, @x_scale)
    elsif @counter.between?(28,35)
      @animation[2].draw_hitbox(x + @offset_x + @reverse_offset_x, y + @offset_y, z, @x_scale)
    else
      @animation[3].draw_hitbox(x + @offset_x + @reverse_offset_x, y + @offset_y, z, @x_scale)
    end
  end

  def init_anim_sprites
    @imgs = Gosu::Image.load_tiles("../../assets/sprites/Enemies/wolf_boss_57x42_alt.png", 57, 42, retro: true)
    @idle_anim = [@imgs[0], @imgs[1],@imgs[2],@imgs[1], @imgs[0]]
    @walking_anim = [@imgs[0], @imgs[3], @imgs[4], @imgs[5], @imgs[6], @imgs[0]]
    @howling_anim = [[@imgs[7],0.05], [@imgs[8],0.05],[@imgs[9],0.05],[@imgs[10],0.7],[@imgs[9],0.05],[@imgs[8],0.05],[@imgs[7],0.05]]
    @attacking = [@imgs[11],@imgs[12], @imgs[13], @imgs[14]]
    @recoiling = [@imgs[8], @imgs[9]]
    @dying = [@imgs[8], @imgs[10], @imgs[11], @imgs[12], @imgs[13]]
  end

  def gime_right_anim
    if moving? || approaching?
      return @walking_anim
    elsif recoiling?
      return @recoiling
    elsif attacking?
      return @attacking
    elsif dying?
      return @dying
    elsif idle?
      return @idle_anim
    end
  end

  def howling?
    return @state == :howling
  end

  def approaching?
    return @state == :approaching
  end
end