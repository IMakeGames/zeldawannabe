require 'gosu'
require '../../src/obj/chars/mc'
require '../../src/obj/chars/wolf'
require '../../src/obj/game_states'
require '../../src/obj/interface'
require '../../src/obj/map/main_map'

class MyWindow < Gosu::Window
  attr_reader :fps, :draw_hb, :w_height, :w_width, :player, :current_map, :kb_locked, :command_stack, :interface,
              :global_frame_counter, :color_value
  attr_writer :kb_locked
  WINDOW_HEIGHT = 720
  WINDOW_WIDTH = 800

  def initialize
    @fps = 50
    @draw_hb = false

    super WINDOW_WIDTH, WINDOW_HEIGHT, update_interval: 1000/@fps
    @half_screen_height = ((WINDOW_HEIGHT/3)/2).ceil
    @half_screen_width = ((WINDOW_WIDTH/3)/2).ceil
    @map_offsetx = 0
    @map_offsety = 0
    @command_stack = []
    @initializing_map= true
    @kb_locked = false
    @global_frame_counter = 0
  end

  def button_down(id)
    #TODO: DRAWS HITBOXES TO TEST STUFF
    if id == Gosu::KB_H
      @draw_hb = @draw_hb ? false : true
    end
    #TODO: DRAWS WHATEVER ELSE NEEDS TESTING
    if id == Gosu::KB_C
      perform_custom_action
    end
    case id
      when Gosu::KB_LEFT
        @command_stack << [:MOVE, GameStates::FaceDir::LEFT]
      when Gosu::KB_RIGHT
        @command_stack << [:MOVE, GameStates::FaceDir::RIGHT]
      when Gosu::KB_UP
        @command_stack << [:MOVE, GameStates::FaceDir::UP]
      when Gosu::KB_DOWN
        @command_stack << [:MOVE, GameStates::FaceDir::DOWN]
      when Gosu::KB_A
        @kb_locked ? nil : @command_stack << [:ATTACK, Gosu::KB_A]
      when Gosu::KB_SPACE
        @kb_locked ? nil : @command_stack << [:ROLL, Gosu::KB_SPACE]
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
    @command_stack.delete_if {|pair|
      pair[1] == dir
    }
  end

  def update
    #PLAYER UPDATE
    @player.update unless @player.dead?

    #TODO: ADD FIRST HEART SCALING EFFECT
    #@interface.update

    #MAP UPDATE
    @current_map.update unless @player.dying? || @player.dead?

    #WINDOW SCROLLING
    if @player.hb.y > @half_screen_height
      @map_offsety = (@half_screen_height - @player.hb.y)
    end
    if @player.hb.x > @half_screen_width
      @map_offsetx = (@half_screen_width - @player.hb.x)
    end
    @global_frame_counter = @global_frame_counter < 51 ? @global_frame_counter + 1 : 0
  end

  def draw
    Gosu.scale(3, 3) {
      @interface.draw
      Gosu.translate(@map_offsetx-1, @map_offsety+59) {
        if @initializing_map
          @current_map.draw_bg
          @current_map.set_indices
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
    @player = Mc.new(100, 100)
    @interface = Interface.new
  end

  def perform_custom_action
    #puts "angle between player and bat" + Gosu.angle(@player.hb.x, @player.hb.y, @current_map.enemies.first.hb.x,  @current_map.enemies.first.hb.y).to_s
    # puts "SOLID TILES COUNT = " + @current_map.solid_tiles.count.to_s
    # @current_map.solid_tiles.each_with_index do |tile, index|
    #   puts "Tile #{index}) x,y{#{tile.x},#{tile.y}} height = #{tile.h} width = #{tile.w}"
    # end
    #
    # puts "SOLID HITBOXES COUNT = " + @current_map.solid_hbs.count.to_s
    # @current_map.solid_hbs.each_with_index do |tile, index|
    #   puts "Hitbox #{index}) x,y{#{tile.x},#{tile.y}} height = #{tile.h} width = #{tile.w}"
    # end
    # if @alpha_channel > 0
    #   @alpha_channel -= 1
    #   puts "ALPHA CHANNEL VALUE: #{@alpha_channel}"
    # end
  end
end
