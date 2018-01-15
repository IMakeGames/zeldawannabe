require 'gosu'
require '../../src/obj/chars/mc'
require '../../src/obj/game_states'
require '../../src/obj/map/main_map'

class MyWindow < Gosu::Window

  def initialize
    super $WINDOW_WIDTH, $WINDOW_HEIGHT, update_interval: 1000/$FPS
    @half_screen_height = (($WINDOW_HEIGHT/3)/2).ceil
    @half_screen_width = (($WINDOW_WIDTH/3)/2).ceil
    self.caption = 'Hello World!'
    $CURRENT_MAP = MainMap.new
    puts $CURRENT_MAP.solid_tiles.count
    @player = Mc.new
    @player.warp(100, 100)
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
    if @player.moving?
      @player.move
    end

    if @player.y > @half_screen_height

      $map_offsety = (@half_screen_height - @player.y)*3
    end
    if @player.x > @half_screen_width

      $map_offsetx = (@half_screen_width - @player.x)*3
    end
  end

  def draw
    Gosu.translate($map_offsetx, $map_offsety){
    Gosu.scale(3, 3) {
      $CURRENT_MAP.draw
      @player.draw
      #Gosu::Font.new(10).draw(Gosu.fps,2,2,2,1,1,$COLOR_BLUE)
    }
    }
  end
end
