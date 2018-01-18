
class WolfSprite < Sprite
  WALKING_ANIM_DURATION = 0.90
  IDLE_ANIM_DURATION = 3

  def initialize
    init_anim_sprites
    change_dir(GameStates::FaceDir::LEFT)
    change_state(GameStates::States::IDLE)
    @counter = 0
    @offset_x = -5
    @offset_y = -5
    @loop = true
  end

  def change_dir(dir)
    if @face_dir != dir
      @face_dir = dir
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
        when GameStates::States::ATTACKING
          @loop = false
          @total = ATTACKING_ANIM_DURATION*$WINDOW.fps
      end

      @animation = gime_right_anim
      @frame_duration = (@total/@animation.count).floor
      @total = (@frame_duration*@animation.count) < @total ? @frame_duration*@animation.count : @total
      @frame_num = 1
      @counter = 0
      #TODO: THIS CODE CAN HELP ANALIZING THE ANIMATIONS' TIME DURATION
      # if state == GameStates::States::ATTACKING
      #   puts "anim count = "+@animation.count.to_s+" total duration = "+@total.to_s+" frame duration = "+ @frame_duration.to_s
      # end
    end
  end

  def animate(x, y, z)
    if @counter.between?(@frame_duration*(@frame_num - 1), @frame_duration*@frame_num)
      @img = @animation[@frame_num -1]
    else
      @frame_num += 1
    end

    @counter += 1

    if @face_dir == GameStates::FaceDir::LEFT
      x_scale = 1
      reverse_offset_x = 0
    else
      x_scale = -1
      reverse_offset_x = 15
    end
    @img.draw(x + @offset_x + reverse_offset_x,y + @offset_y,z,x_scale)

    if @counter >= @total
      if @loop
        @counter = 0
        @frame_num = 1
        change_dir(GameStates::FaceDir.opposite_of(@face_dir))
      end
    end
  end

  def init_anim_sprites
    @imgs = Gosu::Image.load_tiles("../../assets/sprites/Enemies/wolf.png", 18, 16, retro: true)
    @idle_anim        =  [@imgs[0],@imgs[1]]
    @walking_anim     =  [@imgs[4],@imgs[5]]
  end

  def gime_right_anim
    if moving?
      return @walking_anim
    else
      return @idle_anim
    end
  end
end