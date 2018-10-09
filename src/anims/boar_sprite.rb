class BoarSprite < Sprite
  attr_accessor :impacted

  def initialize
    init_anim_sprites
    change_dir(GameStates::FaceDir::LEFT)
    change_state(GameStates::States::IDLE)
    @counter = 0
    @offset_x = -5
    @offset_y = -5
    @y_vel = -4
    @y_pos = nil
    @y_acc = 0.5
    @impacted = false
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
    end
  end

  def change_state(state)
    if @state != state
      @state = state
      case state
        when GameStates::States::WALKING
          @loop = true
          @total = 25
        when GameStates::States::IDLE
          @total = 100
          @index = 0
          @img_pair = @idle_anim[@index]
          return
        when GameStates::States::ATTACKING
          @loop = true
          @total = 6
        when GameStates::States::RECOILING
          change_dir(GameStates::FaceDir.opposite_of(@face_dir))
          @x_special = 1
          @counter = 0
          @y_pos = nil
          @y_vel = -4
          return
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
      # if state == GameStates::States::ATTACKING
      #   puts "anim count = "+@animation.count.to_s+" total duration = "+@total.to_s+" frame duration = "+ @frame_duration.to_s
      # end
    end
  end

  def animate_linear(x, y, z)
    if idle?
      animate_custom(x, y, z)
    elsif recoiling?
      if @y_pos == nil
        @y_pos = y
      end
      if @counter > 13
        @x_special = -1*@x_special unless @counter > 30
        equis = x-3+@x_special+@reverse_offset_x
        i = y + @offset_y
        @recoiling.draw(equis, i, z, @x_scale)
      else
        @y_pos += @y_vel
        @y_vel += @y_acc
        equis = x-3+@reverse_offset_x
        i = @y_pos
        @recoiling.draw(equis, i, z, @x_scale)
      end
      case @face_dir
        when GameStates::FaceDir::LEFT
          @shadow.draw(x-3, y-5, 1)
        when GameStates::FaceDir::RIGHT
          @shadow.draw(x-13, y-5, 1)
      end
    else
      if @counter.between?(@frame_duration*(@frame_num - 1), @frame_duration*@frame_num)
        @img = @frame_num - 1 < @animation.count ? @animation[@frame_num -1] : @animation[@animation.count -1]
      else
        @frame_num += 1
      end
      equis = x + @offset_x + @reverse_offset_x
      i = y + @offset_y
      @img.draw(equis, i, z, @x_scale)

      if @counter >= @total
        if @loop
          @counter = 0
          @frame_num = 1
        end
      end
    end
    if @impacted && !dying? && @counter%3 == 0
      @damaged.draw(equis, i, z+1, @x_scale)
    end
    @counter += 1
  end

  def animate_custom(x, y, z)
    if @counter >= @total*@img_pair[1]
      if @index < @idle_anim.count - 1
        @index += 1
      else
        @index = 0
        change_dir(GameStates::FaceDir.opposite_of(@face_dir))
      end
      @img_pair = @idle_anim[@index]
      @counter = 0
    end
    @img_pair[0].draw(x + @offset_x + @reverse_offset_x, y + @offset_y, z, @x_scale)
  end


  def init_anim_sprites
    @imgs = Gosu::Image.load_tiles("../../assets/sprites/Enemies/boar_25x14.png", 25, 14, retro: true)
    @idle_anim = [[@imgs[0], 0.3], [@imgs[1], 0.1], [@imgs[2], 0.1], [@imgs[1], 0.1], [@imgs[2], 0.1],[@imgs[0],0.3]]
    @walking_anim = [@imgs[5], @imgs[6]]
    @aware = @imgs[4]
    @attacking = [@imgs[8], @imgs[9]]
    @recoiling = @imgs[7]
    @shadow = @imgs[15]
    @damaged = @imgs[3]
    @dying = [@imgs[11], @imgs[12], @imgs[13], @imgs[14]]
  end

  def gime_right_anim
    if moving?
      return @walking_anim
    elsif attacking?
      return @attacking
    elsif dying?
      return @dying
    end
  end
end