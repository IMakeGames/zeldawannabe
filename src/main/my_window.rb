require 'gosu'
require '../../src/obj/chars/mc'
require '../../src/obj/game_states'
class MyWindow < Gosu::Window

  def initialize
    super 640, 480, update_interval: 1000/$FPS
    self.caption = 'Hello World!'
    begin
      @background_imga = Gosu::Image.new("../../assets/sprites/Mapas/RealZone1.png", retro:true)
      @player = Mc.new
      @player.warp(100, 100)
    rescue Exception => e
      puts e.to_s
    end
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
    Gosu.scale(3, 3){
      @player.draw
      @background_imga.draw(0, 0, 0)
    }
  end
end
