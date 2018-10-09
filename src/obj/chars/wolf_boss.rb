require '../anims/wolf_boss_sprite'
class WolfBoss < Char
  ATTACK_PROBABILITY = 50
  HOWLING_PROBABILITY = 5

  def initialize(x, y)
    super(x, y, 20, 20, true)
    @face_dir = GameStates::FaceDir::LEFT
    @sprite = WolfBossSprite.new
    change_state(GameStates::States::IDLE)
    @attack_x_speed = 0
    @attack_y_speed = 0
    @attack_dmg = 2
    @total_hp = 4
    @current_hp = 4
    @minions = []
    @performing_attack = false
  end

  def update
    if $WINDOW.global_frame_counter%10==0 && !@minions.empty?
      @minions.each do |minion|
        if !$WINDOW.current_map.enemies.include?(minion)
          @minions.delete(minion)
        end
      end
    end
    if moving?
      couldnt_move_in_x = move_in_x(@xmag, 1)
      couldnt_move_in_y = move_in_y(@ymag, 1)

      if couldnt_move_in_x || couldnt_move_in_y
        dieroll = Random.rand(100)
        if dieroll < 50
          xbfor = @xmag
          @xmag = -1*@xmag
          @ymag = -1*@ymag

          xaftr = @xmag
        else
          if couldnt_move_in_x
            xbfor = @xmag
            @xmag = -1*@xmag
            xaftr = @xmag
          else
            @ymag = -1*@ymag
          end
        end
        if @xmag < 0
          change_dir(GameStates::FaceDir::LEFT)
        else
          change_dir(GameStates::FaceDir::RIGHT)
        end
      end
    elsif approaching?
      if Gosu.distance(@hb.x, @hb.y, $WINDOW.player.hb.x, $WINDOW.player.hb.y) < 40
        change_state(GameStates::States::ATTACKING)
      else
        move_x = approach($WINDOW.player, 3)
        if move_x < 0 && @face_dir != GameStates::FaceDir::RIGHT
          change_dir(GameStates::FaceDir::RIGHT)
        elsif @face_dir != GameStates::FaceDir::LEFT
          change_dir(GameStates::FaceDir::LEFT)
        end
      end
    elsif attacking? && @event_tiks.between?(5, 15)
      move_x = approach($WINDOW.player, 6)
      if move_x < 0 && @face_dir != GameStates::FaceDir::RIGHT
        change_dir(GameStates::FaceDir::RIGHT)
      elsif @face_dir != GameStates::FaceDir::LEFT
        change_dir(GameStates::FaceDir::LEFT)
      end
    elsif recoiling?
      recoil
    elsif dying?
      @event_tiks == 0 ? die : @event_tiks -= 1
    end

    if normal? && $WINDOW.player.inv_frames <= 0 && !$WINDOW.player.recoiling? && @hb.check_brute_collision($WINDOW.player.hb)
      $WINDOW.player.impacted(@hb.center, @attack_dmg)
    end

    if @event_tiks <= 0
      if moving?
        decide_what_to_do_next
      elsif attacking? || idle? || howling?
        change_state(GameStates::States::WALKING)
      end
      howling? ? spawn_wolves : nil
    elsif !approaching?
      @event_tiks -= 1
    end
    super
  end

  def spawn_wolves
    puts "Spawning Wolves"
    2.times do |n|
      puts "Spawinig Wolf n°#{n  + 1}"
      spawn = false
      loop do
        angle = Random.rand*360
        puts "Angle: #{angle}"
        x_pos = Gosu.offset_x(angle, 25) + @hb.x
        y_pos = Gosu.offset_y(angle, 25) + @hb.y
        puts "trying to spawn at x: #{x_pos}, y: #{y_pos}"
        new_hb = HitBox.new(x_pos, y_pos, 6, 8)

        $WINDOW.current_map.solid_game_objects.each do |obj|
          if obj.hb.check_brute_collision(new_hb)
            puts "cannot spawn at x: #{x_pos}, y: #{y_pos}"
            next
          end
        end

        @minions << $WINDOW.current_map.spawn_wolf(x_pos,y_pos)
        puts "Minion Wolf Spawned"
        spawn = true
        break if spawn
      end
    end
  end

  def decide_what_to_do_next
    dieroll = Random.rand * 100
    if @minions.empty?
      howl_prob = 30
      attack_prob = 30
      idle_prob = 40
    else
      howl_prob = 0
      attack_prob = 40

    end
    if howl_prob > 0 && dieroll.between?(0, howl_prob)
      @event_tiks = 71
      change_state(:howling)
    elsif (dieroll - howl_prob).between?(0, attack_prob)
      change_state(:approaching)
      @event_tiks = 1
    else
      change_state(GameStates::States::IDLE)
    end
  end

  def change_state(state)
    super(state)
    if idle?
      @event_tiks = 75
    elsif attacking?
      @event_tiks = 40
    elsif moving?
      dieroll = Random.rand(100)
      if dieroll.between?(0, 13)
        @angle = 22.5
      elsif dieroll.between?(14, 25)
        @angle = 67.5
      elsif dieroll.between?(26, 38)
        @angle = 112.5
      elsif dieroll.between?(39, 50)
        @angle = 157.5
      elsif dieroll.between?(51, 63)
        @angle = 202.5
      elsif dieroll.between?(54, 75)
        @angle = 247.5
      elsif dieroll.between?(76, 88)
        @angle = 292.5
      else
        @angle = 337.5
      end
      @xmag = Gosu.offset_x(@angle, 2)
      @ymag = Gosu.offset_y(@angle, 2)
      @event_tiks = 100
      if @xmag < 0
        change_dir(GameStates::FaceDir::LEFT)
      else
        change_dir(GameStates::FaceDir::RIGHT)
      end
    end
  end

  def howling?
    return @state == :howling
  end

  def approaching?
    return @state == :approaching
  end
end