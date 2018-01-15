require 'gosu'
require '../../src/obj/chars/mc'
require '../../src/obj/game_states'
require '../../src/obj/map/main_map'

class MyWindow < Gosu::Window

  def initialize
    super 800, 600, update_interval: 1000/$FPS
    self.caption = 'Hello World!'
    @bg_map = MainMap.new
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
    puts "BUTTON RELEASED"
  end

  def update
    if @player.moving?
      @player.move
    end
  end

  def draw
    Gosu.scale(3, 3) {
      @bg_map.draw
      @player.draw
    }
  end
end
