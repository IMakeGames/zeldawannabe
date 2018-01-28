require_relative 'projectile'
require '../anims/poison_puff_sprite'
class PoisonPuff < Projectile

  def initialize(x,y,dir)
    super(x,y,7,7,dir,3,:bad,2)
    @sprite = PoisonPuffSprite.new
    $WINDOW.current_map.projectiles << self
  end
end