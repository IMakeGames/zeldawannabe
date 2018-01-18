require 'gosu'
require '../../src/obj/chars/mc'
require '../../src/obj/chars/wolf'
require '../../src/obj/game_states'
require '../../src/obj/interface'
require '../../src/obj/map/main_map'

class MyWindow < Gosu::Window
  attr_reader :fps, :draw_hb, :color_red, :color_blue, :color_yellow, :w_height, :w_width, :player, :current_map,
              :kb_locked, :command_stack
  attr_writer :kb_locked
  WINDOW_HEIGHT = 720
  WINDOW_WIDTH = 800

  def initialize
    @fps = 50
    @draw_hb = true
    @color_red = Gosu::Color.argb(0xff_ff0000)
    @color_blue = Gosu::Color.argb(0xff_0000ff)
    @color_yellow = Gosu::Color.argb(0xff_ffff00)
    super WINDOW_WIDTH, WINDOW_HEIGHT, update_interval: 1000/@fps
    @half_screen_height = ((WINDOW_HEIGHT/3)/2).ceil
    @half_screen_width = ((WINDOW_WIDTH/3)/2).ceil
    @map_offsetx = 0
    @map_offsety = 0
    @command_stack = []
    @initializing_map= true
    @kb_locked = false
  end

  def button_down(id)
    if id == Gosu::KB_H
      @draw_hb = @draw_hb ? false : true
    end
    case id
      when Gosu::KB_LEFT
        @command_stack << {:MOVE => GameStates::FaceDir::LEFT}
      when Gosu::KB_RIGHT
        @command_stack << {:MOVE => GameStates::FaceDir::RIGHT}
      when Gosu::KB_UP
        @command_stack << {:MOVE => GameStates::FaceDir::UP}
      when Gosu::KB_DOWN
        @command_stack << {:MOVE => GameStates::FaceDir::DOWN}
      when Gosu::KB_A
        @kb_locked ? nil : @command_stack << {:ATTACK => Gosu::KB_A}
    end
  end

  def button_up(id)
    case id
      when Gosu::KB_LEFT
        dir = GameStates::FaceDir::LEFT
      when Gosu::KB_RIGHT
        dir = GameStates::FaceDir::RIGHT
      when Gosu::KB_UP
        dir = GameStates::FaceDir::UP
      when Gosu::KB_DOWN
        dir = GameStates::FaceDir::DOWN
    end
    @command_stack.delete_if {|hash|
      hash.values.last == dir
    }
  end

  def update
    #PLAYER UPDATE
    @player.update

    #MAP UPDATE
    @current_map.update

    #WINDOW SCROLLING
    if @player.hb.y > @half_screen_height
      @map_offsety = (@half_screen_height - @player.hb.y)
    end
    if @player.hb.x > @half_screen_width
      @map_offsetx = (@half_screen_width - @player.hb.x)
    end
  end

  def draw
    Gosu.scale(3, 3) {
      @interface.draw
      Gosu.translate(@map_offsetx-1, @map_offsety+59) {
        if @initializing_map
          @current_map.draw_bg
          @initializing_map = false
        else
          @current_map.draw
          @player.draw
          #Gosu::Font.new(10).draw(Gosu.fps,2,2,2,1,1,$COLOR_BLUE)
        end
      }
    }
  end

  def init_objects
    @current_map = MainMap.new
    @interface = Interface.new
    @player = Mc.new(100, 100)
  end
end
