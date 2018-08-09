class SwordObject

  def initialize(face_dir, player_hb)
    @player_hb = player_hb
    @sah = [HitBox.new(0, 0, 2, 3), HitBox.new(0, 0, 2, 3)]
    @sia = 0
    case face_dir
      when GameStates::FaceDir::UP
        @sia = 292.5
      when GameStates::FaceDir::RIGHT
        @sia = 22.5
      when GameStates::FaceDir::DOWN
        @sia = 112.5
      when GameStates::FaceDir::LEFT
        @sia = 202.5
    end
  end

  def rotate_sword(angle)
    mid_point_adjusted_y = @player_hb.center[1]
    mid_point_adjusted_x = @player_hb.center[0]
    case @face_dir
      when GameStates::FaceDir::DOWN
        mid_point_adjusted_y -= 2
      when GameStates::FaceDir::LEFT
        mid_point_adjusted_x -= 3
      when GameStates::FaceDir::UP
        mid_point_adjusted_y -= 3
    end
    @sah[0].place(mid_point_adjusted_x+Gosu.offset_x(angle, 8), mid_point_adjusted_y+Gosu.offset_y(angle, 8))

    @sah[1].place(mid_point_adjusted_x+Gosu.offset_x(angle, 13), mid_point_adjusted_y+Gosu.offset_y(angle, 14))
  end

  def update
    @sia += 10
    rotate_sword(@sia)
    @sah.each do |hb|
      $WINDOW.current_map.enemies.each do |enemy|
        if !enemy.dying? && ((!enemy.recoiling? && !enemy.is_a?(Boar)) || (enemy.is_a?(Boar) && enemy.inv_frames <= 0)) && hb.check_brute_collision(enemy.hb)
          enemy.impacted(@hb.center, @attack_dmg)
        end
      end
      $WINDOW.current_map.bushes.each do |bush|
        if hb.check_brute_collision(bush.hb)
          bush.impacted
        end
      end
    end
  end
end