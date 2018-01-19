class Interface

  def initialize
    @interface_bg = Gosu::Image.new("../../assets/sprites/Interface/Interface_as_is.png", retro: true)
    @playerHP = $WINDOW.player.current_hp
    @needs_redraw = true
    recalculate_hearts
    @next_print_red = false
  end

  def draw
    if @needs_redraw
      @interface = Gosu.record(267, 60) {
        @interface_bg.draw(0, 0, 0)
        @hearts.each_with_index do |heart, index|
          line = 0
          if index > 8
            index = index - 8
            line = 1
          end
          heart.draw(index, line, 1)
        end
      }
      @needs_redraw = false
    end
    if @next_print_red
      Gosu.draw_rect(0, 0, 267, 60, $WINDOW.color_red, 100)
      @next_print_red = false
    else
      @interface.draw(0, 0, 100)
    end

  end

  def update
    if $WINDOW.player.current_hp <= 0
      @hearts[0].hp = 0
    else
      diff = @playerHP - $WINDOW.player.current_hp
      heart_i = @hearts.count - 1
      while diff > 0 && heart_i >= 0
        if @hearts[heart_i].empty?
          heart_i -= 1
          next
        else
          @hearts[heart_i].hp -= 1
          diff -= 1
        end
      end
    end
    @playerHP = $WINDOW.player.current_hp
    @needs_redraw = true
  end

  def recalculate_hearts
    @hearts = []
    ($WINDOW.player.total_hp/4).times do |n|
      @hearts << Heart.new
    end
  end

  def next_print_red
    @next_print_red = true
  end

  class Heart
    attr_accessor :hp, :active

    def initialize
      @pieces = Gosu::Image.load_tiles("../../assets/sprites/Interface/hearts.png", 11, 9, retro: true)
      @hp = 4
    end

    def draw(n, l, scale)
      ind = 4 - @hp
      @pieces[ind].draw(16 + 11*n, 20+9*l, 3, scale)
    end

    def empty?
      return @hp == 0
    end
  end
end