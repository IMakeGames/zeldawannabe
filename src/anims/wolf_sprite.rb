
class WolfSprite < Sprite
  WALKING_ANIM_DURATION = 0.90
  IDLE_ANIM_DURATION = 2

  def initialize
    super
    init_anim_sprites
    init_anim_durations
    @reverse = false
  end

  def change_dir(dir)
    @face_dir = dir
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
        @total = WALKING_ANIM_DURATION*$WINDOW.fps
      when GameStates::States::IDLE
        @total = IDLE_ANIM_DURATION*$WINDOW.fps
    end
    @quarter = (@total/4).ceil
    @half = (@total/2).ceil
    @tquarter = @quarter*3
  end

  def animate(x, y, z)
    if @counter.between?(0,@half-1)
      @img = gime_right_anim[0]
    else
      @img = gime_right_anim[1]
    end

    if @counter >= @total
      @counter = 0
      #@face_dir = GameStates::FaceDir.oposite_of(@face_dir)
    end

    @counter += 1

    x_scale = @face_dir == GameStates::FaceDir::LEFT ? 1 : -1
    @img.draw(x,y,z)
  end

  def init_anim_durations
    @counter = 0
    @total = IDLE_ANIM_DURATION*$WINDOW.fps
    @quarter = (@total/4).ceil
    @half = (@total/2).ceil
    @tquarter = @quarter*3
  end


  def init_anim_sprites
    @imgs = Gosu::Image.load_tiles("../../assets/sprites/Enemies/wolf.png", 18, 16, retro: true)
    @idle_anim        =  [@imgs[0],@imgs[1]]
    @walking_anim     =  [@imgs[4],@imgs[5]]
    @current_anim = @idle_anim
  end

  def gime_right_anim
    case @face_dir
      when GameStates::FaceDir::UP
      when GameStates::FaceDir::DOWN
      when GameStates::FaceDir::LEFT
        if moving?
          return @walking_anim
        else
          return @idle_anim
        end
      when GameStates::FaceDir::RIGHT
        if moving?
          return @walking_anim
        else
          return @idle_anim
        end
    end
  end
end