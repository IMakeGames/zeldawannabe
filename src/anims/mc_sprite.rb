require_relative 'sprite'
class McSprite < Sprite
  WALKING_ANIM_DURATION = 0.90
  IDLE_ANIM_DURATION = 2
  ATTACKING_ANIM_DURATION = 0.25

  def initialize
    init_anim_sprites
    @counter = 0
    @offset_x = -6
    @offset_y = -9
    @loop = true
    @reverse = false
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
          @total = 30
        when GameStates::States::IDLE
          @loop = true
          @total = 80
        when GameStates::States::ATTACKING
          @loop = false
          @total = 9
        when GameStates::States::RECOILING
          @loop = true
          @total = 8
        when GameStates::States::DYING
          @loop = true
          @total = 20
        when   GameStates::States::ROLLING
          @loop = false
          @total = 25
        when GameStates::States::SHEATHING
          @reverse = $WINDOW.player.unsheathed ? true : false
          @loop = false
          @total = 15
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

  def animate_linear(x, y, z)
    if @counter.between?(@frame_duration*(@frame_num - 1), @frame_duration*@frame_num)
      @img = @animation[@frame_num -1]
    else
      @frame_num += 1
    end

    if @counter >= @total
      if @loop
        @counter = 0
        @frame_num = 1
      else
        #TODO: THIS CODE HERE MUST BE ANALIZED FOR WHETHER IT IS REALLY USEFUL OR NOT
        # change_state(GameStates::States::IDLE)
        # @img = @animation[@frame_num -1]
      end
    else
      @counter += 1
    end
      @img.draw_hitbox(x+@offset_x, y+@offset_y, z, @x_scale)
  end

  def init_anim_sprites
    @imgs = Gosu::Image.load_tiles("../../assets/sprites/MainChar/mc_sprites_18x20_alt.png", 18, 20, retro: true)
    @atk = Gosu::Image.load_tiles("../../assets/sprites/MainChar/sword_attack_29x29_alt2.png", 29, 29, retro: true)

    @down_idle_anim = [@imgs[0], @imgs[3], @imgs[4]]
    @right_idle_anim = [@imgs[10], @imgs[13], @imgs[14]]
    @up_idle_anim = [@imgs[20], @imgs[23], @imgs[24]]
    @left_idle_anim = [@imgs[30], @imgs[33], @imgs[34]]

    @down_walking_anim = [@imgs[1], @imgs[0], @imgs[2],@imgs[0]]
    @right_walking_anim = [@imgs[11], @imgs[10], @imgs[12],@imgs[10]]
    @up_walking_anim = [@imgs[21], @imgs[20], @imgs[22],@imgs[20]]
    @left_walking_anim = [@imgs[31], @imgs[30], @imgs[32], @imgs[30]]

    @down_unsheath = [@imgs[45], @imgs[46], @imgs[47], @imgs[48]]
    @down_sheath   = [@imgs[48], @imgs[47], @imgs[46], @imgs[45]]
    @right_unsheath = [@imgs[55], @imgs[56], @imgs[57], @imgs[58]]
    @right_sheath  =  [@imgs[58], @imgs[57], @imgs[56], @imgs[55]]
    @up_unsheath = [@imgs[65], @imgs[66], @imgs[67], @imgs[68]]
    @up_sheath   = [@imgs[68], @imgs[67], @imgs[66], @imgs[65]]
    @left_unsheath = [@imgs[75], @imgs[76], @imgs[77], @imgs[78]]
    @left_sheath = [@imgs[78], @imgs[77], @imgs[76], @imgs[75]]

    @down_sword_idle_anim = [@imgs[40], @imgs[43], @imgs[44]]
    @right_sword_idle_anim = [@imgs[50], @imgs[53], @imgs[54]]
    @up_sword_idle_anim = [@imgs[60], @imgs[63], @imgs[14]]
    @left_sword_idle_anim = [@imgs[70], @imgs[73], @imgs[74]]

    @down_sword_walking_anim = [@imgs[41], @imgs[40], @imgs[42], @imgs[40]]
    @right_sword_walking_anim = [@imgs[51], @imgs[50], @imgs[52], @imgs[50]]
    @up_sword_walking_anim = [@imgs[61], @imgs[60], @imgs[62], @imgs[60]]
    @left_sword_walking_anim = [@imgs[71], @imgs[70], @imgs[72], @imgs[70]]

    @down_block = [@imgs[35]]
    @right_block = [@imgs[36]]
    @left_block = [@imgs[37]]
    @up_block = [@imgs[38]]

    @damaged = [@imgs[39], @imgs[49]]

    @down_rolling = [@imgs[4],@imgs[5], @imgs[6], @imgs[7], @imgs[8], @imgs[9],@imgs[4]]
    @side_rolling = [@imgs[14],@imgs[15], @imgs[16], @imgs[17], @imgs[18], @imgs[19],@imgs[14]]
    @up_rolling = [@imgs[24],@imgs[25], @imgs[26], @imgs[27], @imgs[28], @imgs[29],@imgs[24]]

    @down_sword_attacking = [@atk[0], @atk[1], @atk[2], @atk[3]]
    @right_sword_attacking = [@atk[4], @atk[5], @atk[6], @atk[7]]
    @up_sword_attacking = [@atk[8], @atk[9], @atk[10], @atk[11]]
    @left_sword_attacking = [@atk[12], @atk[13], @atk[14], @atk[15]]

    @dying = [@imgs[0],@imgs[30],@imgs[20],@imgs[10]]

    @dead  = @imgs[59]

  end

  def gime_right_anim
    offset18x20
    @x_scale = 1
    if recoiling?
      return @damaged
    elsif dying?
      return @dying
    else
      case @face_dir
        when GameStates::FaceDir::UP
          if moving?
            return $WINDOW.player.unsheathed ? @up_sword_walking_anim : @up_walking_anim
          elsif attacking?
            @offset_x = -10
            @offset_y = -14
            return @up_sword_attacking
          elsif rolling?
            return @up_rolling
          elsif sheathing?
            return @reverse ? @up_sheath : @up_unsheath
          elsif blocking?
            return @up_block
          else
            return $WINDOW.player.unsheathed ? @up_sword_idle_anim : @up_idle_anim
          end
        when GameStates::FaceDir::DOWN
          if moving?
            return $WINDOW.player.unsheathed ? @down_sword_walking_anim : @down_walking_anim
          elsif attacking?
            @offset_x = -10
            @offset_y = -9
            return @down_sword_attacking
          elsif rolling?
            return @down_rolling
          elsif sheathing?
            return @reverse ? @down_sheath : @down_unsheath
          elsif blocking?
            return @down_block
          else
            return $WINDOW.player.unsheathed ? @down_sword_idle_anim : @down_idle_anim
          end
        when GameStates::FaceDir::LEFT
          if moving?
            return $WINDOW.player.unsheathed ? @left_sword_walking_anim : @left_walking_anim
          elsif attacking?
            @offset_x = -13
            @offset_y = -8
            return @left_sword_attacking
          elsif rolling?
            @x_scale = -1
            @offset_x = 10
            return @side_rolling
          elsif sheathing?
            return @reverse ? @left_sheath  : @left_unsheath
          elsif blocking?
            return @left_block
          else
            return $WINDOW.player.unsheathed ? @left_sword_idle_anim : @left_idle_anim
          end
        when GameStates::FaceDir::RIGHT
          if moving?
            return $WINDOW.player.unsheathed ? @right_sword_walking_anim : @right_walking_anim
          elsif attacking?
            @offset_x = -11
            @offset_y = -8
            return @right_sword_attacking
          elsif rolling?
            return @side_rolling
          elsif sheathing?
            return @reverse ? @right_sheath : @right_unsheath
          elsif blocking?
            return @right_block
          else
            return $WINDOW.player.unsheathed ? @right_sword_idle_anim : @right_idle_anim
          end
      end
    end
  end

  def offset18x20
    @offset_x = -6
    @offset_y = -9
  end

  def draw_dead(x,y,z)
    @dead.draw_hitbox(x+@offset_x+5, y+@offset_y+4, z)
  end

  def rolling?
    return @state == GameStates::States::ROLLING
  end

  def sheathing?
    return @state == GameStates::States::SHEATHING
  end

  def blocking?
    return @state == GameStates::States::BLOCKING
  end

end