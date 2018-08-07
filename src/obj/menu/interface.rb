class Interface

  def initialize
    @interface_bg = Gosu::Image.new("../../assets/sprites/Interface/Interface_as_is.png", retro: true)
    @sword_and_shield = Gosu::Image.load_tiles("../../assets/sprites/Interface/sword_and_shield.png", 18, 18, retro: true)
    @roll_block = Gosu::Image.load_tiles("../../assets/sprites/Interface/rollblock.png", 24, 9, retro: true)
    @playerHP = $WINDOW.player.current_hp
    @needs_redraw = true
    recalculate_hearts
    @next_print_red = false
  end

  def draw
    if @needs_redraw
      @interface = Gosu.record(267, 60) {
        @interface_bg.draw_hitbox(0, 0, 0)
        @sword_and_shield[@sheathed].draw_hitbox(233, 10, 1)
        @roll_block[@sheathed].draw_hitbox(210, 37, 1)
        @hearts.each_with_index do |heart, index|
          line = 0
          if index > 8
            index = index - 8
            line = 1
          end
          heart.draw_hitbox(index, line, 1)
        end
      }
      @needs_redraw = false
    end
    if @next_print_red
      Gosu.draw_rect(0, 0, 267, 60, Gosu::Color::RED, 100)
      @next_print_red = false
    else
      @interface.draw_hitbox(0, 0, 100)
    end
  end

  def update
    @sheathed = $WINDOW.player.unsheathed ? 0 : 1
    if $WINDOW.player.current_hp <= 0
      @hearts[0].hp = 0
    else
      diff = @playerHP - $WINDOW.player.current_hp
      heart_i = diff > 0 ? @hearts.count - 1 : 0
      while diff != 0 && heart_i >= 0
        if diff > 0
          if @hearts[heart_i].empty?
            heart_i -= 1
            next
          else
            @hearts[heart_i].hp -= 1
            diff -= 1
          end
        elsif diff < 0
          if @hearts[heart_i].hp >= 4
            heart_i += 1
          else
            @hearts[heart_i].hp += 1
            diff +=1
          end
        end
      end
    end

    @playerHP = $WINDOW.player.current_hp
    @needs_redraw = true
    puts "PLAYER'S HP ACCORDING TO INTERFACE: #{@playerHP}"
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
      @pieces[ind].draw_hitbox(16 + 11*n, 20+9*l, 3, scale)
    end

    def empty?
      return @hp == 0
    end
  end
end