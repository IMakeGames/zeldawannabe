
class McSprite
  WALKING_ANIM_DURATION = 0.90
  IDLE_ANIM_DURATION = 2

  def initialize
    init_states
    init_anim_sprites
    init_anim_durations
  end

  def change_dir(dir)
    @dir = dir
    case dir
      when GameStates::FaceDir::UP
        @current_anim = @up_walking_anim
      when GameStates::FaceDir::DOWN
        @current_anim = @down_walking_anim
      when GameStates::FaceDir::LEFT
        @current_anim = @left_walking_anim
      when GameStates::FaceDir::RIGHT
        @current_anim = @right_walking_anim
    end
  end

  def change_state(state)
    @state = state
    case state
      when GameStates::States::MOVING
        @total = WALKING_ANIM_DURATION*$FPS
      when GameStates::States::IDLE
        @total = IDLE_ANIM_DURATION*$FPS
    end
    @quarter = (@total/4).ceil
    @half = (@total/2).ceil
    @tquarter = @quarter*3
  end

  def animate(x, y, z)
    if @counter.between?(0,@quarter - 1)  || @counter.between?(@half,@tquarter - 1)
      @img = gime_right_anim[0]
    elsif @counter.between?(@quarter,@half-1)
      @img = gime_right_anim[1]
    else
      @img = gime_right_anim[2]
    end

    @counter >= @total ? @counter = 0 :
    @counter += 1
    @img.draw(x,y,z)
  end

  def init_anim_durations
    @counter = 0
    @total = IDLE_ANIM_DURATION*$FPS
    @quarter = (@total/4).ceil
    @half = (@total/2).ceil
    @tquarter = @quarter*3
  end


  def init_anim_sprites
    @imgs = Gosu::Image.load_tiles("../../assets/sprites/MainChar/normal_walking_anim.png", 18, 20, retro: true)
    @down_walking_anim  =  [@imgs[0],@imgs[1],@imgs[2]]
    @down_idle_anim     =  [@imgs[0],@imgs[3],@imgs[4]]
    @right_walking_anim =  [@imgs[5],@imgs[6],@imgs[7]]
    @right_idle_anim    =  [@imgs[5],@imgs[8],@imgs[9]]
    @up_walking_anim    =  [@imgs[10],@imgs[11],@imgs[12]]
    @up_idle_anim       =  [@imgs[11],@imgs[13],@imgs[14]]
    @left_walking_anim  =  [@imgs[15],@imgs[16],@imgs[17]]
    @left_idle_anim     =  [@imgs[15],@imgs[18],@imgs[19]]
    @current_anim = @down_walking_anim
  end

  def init_states
    @dir = GameStates::FaceDir::DOWN
    @state = GameStates::States::IDLE
  end

  def gime_right_anim
    case @dir
      when GameStates::FaceDir::UP
        if @state == GameStates::States::MOVING
          return @up_walking_anim
        else
          return @up_idle_anim
        end
      when GameStates::FaceDir::DOWN
        if @state == GameStates::States::MOVING
          return @down_walking_anim
        else
          return @down_idle_anim
        end
      when GameStates::FaceDir::LEFT
        if @state == GameStates::States::MOVING
          return @left_walking_anim
        else
          return @left_idle_anim
        end
      when GameStates::FaceDir::RIGHT
        if @state == GameStates::States::MOVING
          return @right_walking_anim
        else
          return @right_idle_anim
        end
    end
  end
end