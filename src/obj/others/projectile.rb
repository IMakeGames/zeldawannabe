class Projectile < GameObject

  def initialize(x,y,w,h,dir,speed,allegiance, dmg)
    super(x,y,w,h)
    @dir = dir
    @speed = speed
    @allegiance = allegiance
    @attack_dmg = dmg
  end

  def update
    case @dir
      when GameStates::FaceDir::UP
        @hb.y -= @speed
      when GameStates::FaceDir::DOWN
        @hb.y += @speed
      when GameStates::FaceDir::LEFT
        @hb.x -= @speed
      when GameStates::FaceDir::RIGHT
        @hb.x += @speed
    end

    case @allegiance
      when :good
      when :bad
        if $WINDOW.player.invis_frames <= 0 && !$WINDOW.player.recoiling? && @hb.check_brute_collision($WINDOW.player.hb)
          $WINDOW.player.impacted(@hb.center, @attack_dmg)
          die
        end
      when :neutral
    end

    if Gosu.distance(@hb.x,@hb.y,$WINDOW.player.hb.x, $WINDOW.player.hb.y) > 150
      die
    end
  end
end