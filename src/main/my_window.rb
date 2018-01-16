require 'gosu'
require '../../src/obj/chars/mc'
require '../../src/obj/chars/wolf'
require '../../src/obj/game_states'
require '../../src/obj/map/main_map'

class MyWindow < Gosu::Window
  attr_reader :fps, :draw_hb, :color_red, :color_blue, :color_yellow, :w_height, :w_width, :player, :current_map
  WINDOW_HEIGHT = 600
  WINDOW_WIDTH = 800

  def initialize
    @fps = 60
    @draw_hb = false
    @color_red = Gosu::Color.argb(0xff_ff0000)
    @color_blue = Gosu::Color.argb(0xff_0000ff)
    @color_yellow = Gosu::Color.argb(0xff_ffff00)
    super WINDOW_WIDTH, WINDOW_HEIGHT, update_interval: 1000/@fps
    @half_screen_height = ((WINDOW_HEIGHT/3)/2).ceil
    @half_screen_width = ((WINDOW_WIDTH/3)/2).ceil
    @map_offsetx = 0
    @map_offsety = 0
    @initiating = true
    self.caption = 'Hello World!'
  end

  def button_down(id)
    if [Gosu::KB_LEFT, Gosu::KB_RIGHT, Gosu::KB_UP, Gosu::KB_DOWN].include? id
      @player.change_move_state(GameStates::Action::PRESS)
      case id
        when Gosu::KB_LEFT
          @player.change_dir(GameStates::FaceDir::LEFT)
        when Gosu::KB_RIGHT
          @player.change_dir(GameStates::FaceDir::RIGHT)
        when Gosu::KB_UP
          @player.change_dir(GameStates::FaceDir::UP)
        when Gosu::KB_DOWN
          @player.change_dir(GameStates::FaceDir::DOWN)
      end
    end
  end

  def button_up(id)
    if [Gosu::KB_LEFT, Gosu::KB_RIGHT, Gosu::KB_UP, Gosu::KB_DOWN].include? id
      @player.change_move_state(GameStates::Action::RELEASE)
    end
  end

  def update
    #PLAYER UPDATE
    @player.update

    #NPC UPDATE
    @wolf.update

    #WINDOW SCROLLING
    if @player.y > @half_screen_height
      @map_offsety = (@half_screen_height - @player.y)*3
    end
    if @player.x > @half_screen_width
      @map_offsetx = (@half_screen_width - @player.x)*3
    end
  end

  def draw
    Gosu.translate(@map_offsetx, @map_offsety) {
      Gosu.scale(3, 3) {
        if @initiating
          @current_map.draw_bg
          @initiating = false
        else
          @current_map.draw
          @player.draw
          @wolf.draw
          #Gosu::Font.new(10).draw(Gosu.fps,2,2,2,1,1,$COLOR_BLUE)
        end
      }
    }
  end

  def init_objects
    @current_map = MainMap.new
    puts @current_map.solid_tiles.count
    @wolf = Wolf.new
    @player = Mc.new
    @player.place(100, 100)
    @wolf.place(120,120)
  end
end
