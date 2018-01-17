require_relative 'sprite'
class McSprite < Sprite
  WALKING_ANIM_DURATION = 0.90
  IDLE_ANIM_DURATION = 2
  ATTACKING_ANIM_DURATION = 0.3

  def initialize
    super
    init_anim_sprites
    change_state(GameStates::States::IDLE)
    @counter  = 0
    @offset_x = -6
    @offset_y = -9
  end

  def change_dir(dir)
    @face_dir = dir
    @animation = gime_right_anim
  end

  def change_state(state)
    @state = state
    case state
      when GameStates::States::MOVING
        @total = WALKING_ANIM_DURATION*$WINDOW.fps
      when GameStates::States::IDLE
        @total = IDLE_ANIM_DURATION*$WINDOW.fps
      when GameStates::States::ATTACKING
        @total = ATTACKING_ANIM_DURATION*$WINDOW.fps
    end

    @animation = gime_right_anim
    @frame_duration = (@total/@animation.count).ceil
    @frame_num = 1
    @counter = 0
  end

  def animate(x, y, z)
    if @counter.between?(@frame_duration*(@frame_num - 1),@frame_duration*@frame_num)
      @img = @animation[@frame_num -1]
    else
      @frame_num += 1
    end

    if @counter >= @total
      @counter = 0
      @frame_num = 1
    else
      @counter += 1
    end

    @img.draw(x+@offset_x,y+@offset_y,z)
  end

  def init_anim_sprites
    @imgs = Gosu::Image.load_tiles("../../assets/sprites/MainChar/mc_sprites_18x20.png", 18, 20, retro: true)
    @atk = Gosu::Image.load_tiles("../../assets/sprites/MainChar/sword_attack_29x29.png", 29, 29, retro: true)

    @down_idle_anim           =  [@imgs[0],@imgs[3],@imgs[4]]
    @right_idle_anim          =  [@imgs[10],@imgs[13],@imgs[14]]
    @up_idle_anim             =  [@imgs[20],@imgs[23],@imgs[24]]
    @left_idle_anim           =  [@imgs[30],@imgs[33],@imgs[34]]

    @down_walking_anim        =  [@imgs[0],@imgs[1],@imgs[0],@imgs[2]]
    @right_walking_anim       =  [@imgs[10],@imgs[11],@imgs[10],@imgs[12]]
    @up_walking_anim          =  [@imgs[20],@imgs[21],@imgs[20],@imgs[22]]
    @left_walking_anim        =  [@imgs[30],@imgs[31],@imgs[30],@imgs[32]]

    @down_unseath             =  [@imgs[45],@imgs[46],@imgs[47],@imgs[48]]
    @right_unseath            =  [@imgs[55],@imgs[56],@imgs[57],@imgs[58]]
    @up_unseath               =  [@imgs[65],@imgs[66],@imgs[67],@imgs[68]]
    @left_unseath             =  [@imgs[75],@imgs[76],@imgs[77],@imgs[78]]

    @down_sword_idle_anim     =  [@imgs[40],@imgs[43],@imgs[44]]
    @right_sword_idle_anim    =  [@imgs[50],@imgs[53],@imgs[54]]
    @up_sword_idle_anim       =  [@imgs[60],@imgs[63],@imgs[14]]
    @left_sword_idle_anim     =  [@imgs[70],@imgs[73],@imgs[74]]

    @down_sword_walking_anim  =  [@imgs[40],@imgs[41],@imgs[42]]
    @right_sword_walking_anim =  [@imgs[50],@imgs[51],@imgs[52]]
    @up_sword_walking_anim    =  [@imgs[60],@imgs[61],@imgs[62]]
    @left_sword_walking_anim  =  [@imgs[70],@imgs[71],@imgs[72]]

    @down_block               =  @imgs[35]
    @right_block              =  @imgs[36]
    @left_block               =  @imgs[37]
    @up_block                 =  @imgs[38]

    @damaged                  =  [@imgs[39],@imgs[40]]

    @down_rolling             =  [@imgs[5],@imgs[6],@imgs[7],@imgs[8],@imgs[9]]
    @side_rolling             =  [@imgs[15],@imgs[16],@imgs[17],@imgs[18],@imgs[19]]
    @up_rolling               =  [@imgs[25],@imgs[26],@imgs[27],@imgs[28],@imgs[29]]

    @down_sword_attacking     = [@atk[0],@atk[1],@atk[2],@atk[3]]
    @right_sword_attacking    = [@atk[4],@atk[5],@atk[6],@atk[7]]
    @up_sword_attacking       = [@atk[8],@atk[9],@atk[10],@atk[11]]
    @left_sword_attacking     = [@atk[12],@atk[13],@atk[14],@atk[15]]

  end

  def gime_right_anim
    offset18x20
    case @face_dir
      when GameStates::FaceDir::UP
        if moving?
          return @up_walking_anim
        elsif attacking?
          @offset_x = -10
          @offset_y = -14
          return @up_sword_attacking
        else
          return @up_idle_anim
        end
      when GameStates::FaceDir::DOWN
        if moving?
          return @down_walking_anim
        elsif attacking?
          @offset_x = -10
          @offset_y = -8
          return @down_sword_attacking
        else
          return @down_idle_anim
        end
      when GameStates::FaceDir::LEFT
        if moving?
          return @left_walking_anim
        elsif attacking?
          @offset_x = -13
          @offset_y = -8
          return @left_sword_attacking
        else
          return @left_idle_anim
        end
      when GameStates::FaceDir::RIGHT
        if moving?
          return @right_walking_anim
        elsif attacking?
          @offset_x = -10
          @offset_y = -8
          return @right_sword_attacking
        else
          return @right_idle_anim
        end
    end
  end

  def offset18x20
    @offset_x = -6
    @offset_y = -9
  end

end