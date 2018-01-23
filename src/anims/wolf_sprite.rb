class WolfSprite < Sprite
  WALKING_ANIM_DURATION = 0.7
  IDLE_ANIM_DURATION = 3

  def initialize
    init_anim_sprites
    change_dir(GameStates::FaceDir::LEFT)
    change_state(GameStates::States::IDLE)
    @counter = 0
    @offset_x = -5
    @offset_y = -5
  end

  def change_dir(dir)
    if @face_dir != dir
      @face_dir = dir
      if @face_dir == GameStates::FaceDir::LEFT
        @x_scale = 1
        @reverse_offset_x = 0
      else
        @x_scale = -1
        @reverse_offset_x = 15
      end
      @animation = gime_right_anim
    end
  end

  def change_state(state)
    if @state != state
      @state = state
      case state
        when GameStates::States::MOVING
          @loop = true
          @total = WALKING_ANIM_DURATION*$WINDOW.fps
        when GameStates::States::IDLE
          @loop = true
          @total = IDLE_ANIM_DURATION*$WINDOW.fps
        when GameStates::States::CUSTOM
          @loop = false
          @total = 50
        when GameStates::States::ATTACKING
          @loop = false
          @total = 20
        when GameStates::States::RECOILING
          @loop = true
          @total = 6
        when GameStates::States::DYING
          @loop = false
          @total = 20
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
    if preping_attack?
      animate_attack(x, y, z)
    else
      if @counter.between?(@frame_duration*(@frame_num - 1), @frame_duration*@frame_num)
        @img = @frame_num - 1 < @animation.count ? @animation[@frame_num -1] : @animation[@animation.count -1]
      else
        @frame_num += 1
      end

      @img.draw(x + @offset_x + @reverse_offset_x, y + @offset_y, z, @x_scale)

      if @counter >= @total
        if @loop
          @counter = 0
          @frame_num = 1
          if idle?
            change_dir(GameStates::FaceDir.opposite_of(@face_dir))
          end
        end
      end
      @counter += 1
    end
  end

  def animate_attack(x,y,z)
    if @counter < 10
      @animation[1].draw(x + @offset_x + @reverse_offset_x, y + @offset_y, z, @x_scale)
    elsif @counter <40
      attack_prep_offset = @counter%2 == 0 ? 3 : 0
      @animation[0].draw(x + @offset_x + @reverse_offset_x + attack_prep_offset, y + @offset_y, z, @x_scale)
    elsif @counter >=40
      change_state(GameStates::States::ATTACKING)
    end
    @counter += 1
  end

  def init_anim_sprites
    @imgs = Gosu::Image.load_tiles("../../assets/sprites/Enemies/wolf_18x16.png", 18, 16, retro: true)
    @idle_anim = [@imgs[0], @imgs[1]]
    @walking_anim = [@imgs[4], @imgs[2], @imgs[5]]
    @preparing_attack = [@imgs[3], @imgs[4]]
    @attacking = [@imgs[3],@imgs[6], @imgs[7], @imgs[3]]
    @recoiling = [@imgs[8], @imgs[9]]
    @dying = [@imgs[8], @imgs[10], @imgs[11], @imgs[12], @imgs[13]]
  end

  def gime_right_anim
    if moving?
      return @walking_anim
    elsif recoiling?
      return @recoiling
    elsif preping_attack?
      return @preparing_attack
    elsif attacking?
      return @attacking
    elsif dying?
      return @dying
    elsif idle?
      return @idle_anim
    end
  end

  def preping_attack?
    return @state == GameStates::States::CUSTOM
  end
end