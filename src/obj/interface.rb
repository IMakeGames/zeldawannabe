class Interface

  def initialize
    @interface = Gosu::Image.new("../../assets/sprites/Interface/Interface.png", retro: true)
  end

  def draw
    @interface.draw(0,0,100)
  end

end