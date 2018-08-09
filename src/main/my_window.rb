require 'gosu'
require '../../src/obj/chars/main_char'
require '../../src/obj/chars/wolf'
require '../../src/obj/game_states'
require '../../src/obj/menu/interface'
require '../../src/obj/menu/main_menu'
require '../../src/obj/map/main_map'

class MyWindow < Gosu::Window
  attr_reader :fps, :draw_hb, :w_height, :w_width, :player, :current_map, :kb_locked, :interface,
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
    @initializing_map= true
    @kb_locked = false
    @global_frame_counter = 0
    @window_state = :game
  end

  def button_down(id)

    # H BUTTON DRAWS HITBOXES TO TEST STUFF
    if id == Gosu::KB_H
      @draw_hb = !@draw_hb
    end

    # C BUTTON DRAWS WHATEVER ELSE NEEDS TESTING
    if id == Gosu::KB_C
      perform_custom_action
    end

    # D BUTTON CHANGES GAME STATE BETWEEN MENU, GAME, ETC.
    if id == Gosu::KB_D
      if @window_state == :game
        @player.command_stack.clear
        @main_menu = MainMenu.new
      end
      @window_state = @window_state == :game ? :menu : :game
    end

    # DECIDES BUTTON BEHAVIOUR WHEN IN GAME
    if @window_state == :game
        case id
          #TODO: There musn't be more than 2 walking commands in command_stack.
          when Gosu::KB_LEFT
            @player.command_stack << [:WALK, GameStates::FaceDir::LEFT]
            @player.changed_command_stack = true
          when Gosu::KB_RIGHT
            @player.command_stack << [:WALK, GameStates::FaceDir::RIGHT]
            @player.changed_command_stack = true
          when Gosu::KB_UP
            @player.command_stack << [:WALK, GameStates::FaceDir::UP]
            @player.changed_command_stack = true
          when Gosu::KB_DOWN
            @player.command_stack << [:WALK, GameStates::FaceDir::DOWN]
            @player.changed_command_stack = true
          when Gosu::KB_A
            if !@kb_locked && @player.una_tiks <= 0
              to_add = @player.unsheathed ? [:ATTACKORITEM, :ATTACK] : [:ATTACKORITEM, :ITEM]
              @player.command_stack << to_add
              @player.changed_command_stack = true
            end
          when Gosu::KB_SPACE
            if !@kb_locked && @player.unr_tiks <= 0
              to_add = @player.unsheathed ? [:ROLLORBLOCK, :BLOCK] : [:ROLLORBLOCK, :ROLL]
              @player.command_stack << to_add
              @player.changed_command_stack = true
            end
          when Gosu::KB_W
            if !@kb_locked && @player.uns_tiks <= 0
              @player.command_stack << [:SHEATHE_ACTION, Gosu::KB_W]
              @player.changed_command_stack = true
            end
        end
    elsif @window_state == :menu
      #TODO: IMPLEMENT MENU FUNCTIONALITY
    end
  end

  def button_up(id)
    if @window_state == :game
      case id
        when Gosu::KB_LEFT
          dir = GameStates::FaceDir::LEFT
        when Gosu::KB_RIGHT
          dir = GameStates::FaceDir::RIGHT
        when Gosu::KB_UP
          dir = GameStates::FaceDir::UP
        when Gosu::KB_DOWN
          dir = GameStates::FaceDir::DOWN
        # when Gosu::KB_SPACE
        #   if @player.blocking?
        #     @player.command_stack.delete_if {|pair|
        #       pair[1] == :BLOCK
        #     }
        #     @player.state = GameStates::States::IDLE
        #   end
      end
      @player.command_stack.delete_if {|pair|
        pair[1] == dir
      }
      @player.changed_command_stack = true
    end
  end

  def update
    if @window_state == :game
      #PLAYER UPDATE
      @player.update unless @player.dead? || @window_state == :menu

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
    elsif @window_state == :menu
      @main_menu.update
    end
  end

  def draw
    Gosu.scale(3) {
      if @window_state == :game
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
      elsif @window_state == :menu
        @main_menu.draw
      end
    }
  end

  def init_objects
    @current_map = MainMap.new
    @player = MainChar.new(100, 100)
    @interface = Interface.new
    @interface.update
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
