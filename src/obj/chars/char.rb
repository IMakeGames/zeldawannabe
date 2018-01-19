require '../../src/obj/game_states'
require '../../src/obj/game_object'
require_relative 'hit_box'

class Char < GameObject

  attr_accessor :state, :face_dir, :event_tiks, :char_speed, :current_hp, :total_hp, :can_move_x, :can_move_y,
                :recoil_ticks, :attack_dmg

  def initialize(x, y, w, h)
    super(x,y,w,h)
    @event_tiks = 0
    @recoil_ticks = 28
    @recoil_speed_x
    @recoil_speed_y
    @can_move_x = true
    @can_move_y = true
  end

  def idle?
    return @state == GameStates::States::IDLE
  end

  def moving?
    return @state == GameStates::States::MOVING
  end

  def attacking?
    return @state == GameStates::States::ATTACKING
  end

  def recoiling?
    return @state == GameStates::States::RECOILING
  end

  def dying?
    return @state == GameStates::States::DYING
  end

  def place(x, y)
    @hb.place(x, y)
  end

  def change_dir(dir)
    @face_dir = dir
    @sprite.change_dir(dir)
  end

  def change_state(id)
    @state = id
    @sprite.change_state(id)
  end

  def impacted(away_from,attack_dmg)
    @current_hp -= attack_dmg
    angle = Gosu.angle(away_from[0], away_from[1], @hb.x, @hb.y)
    @recoil_speed_x = Gosu.offset_x(angle, 4)
    @recoil_speed_y = Gosu.offset_y(angle, 4)
    change_state(GameStates::States::RECOILING)
    @event_tiks = @current_hp > 0 ? @recoil_ticks : 18
  end

  def update
    raise "UPDATE METHOD MUST BE OVERRIDEN"
  end

  def recoil
    if @event_tiks > (@recoil_ticks*0.61).ceil && @event_tiks < (@recoil_ticks*0.893).ceil
      new_hitbox = HitBox.new(@hb.x + @recoil_speed_x, @hb.y + @recoil_speed_y, @hb.w, @hb.h)
      $WINDOW.current_map.solid_tiles.each do |tile|
        if tile.hb.check_brute_collision(new_hitbox)
          @event_tiks -= 1
          return
        end
      end
      @hb.x += @recoil_speed_x
      @hb.y += @recoil_speed_y
    elsif @event_tiks <= 0
      if @current_hp <=0
        change_state(GameStates::States::DYING)
        @event_tiks = 20
      else
        change_state(GameStates::States::IDLE)
      end
    end
    @event_tiks -=1
  end

  def move
    case @face_dir
      when GameStates::FaceDir::UP
        new_hitbox = HitBox.new(@hb.x, @hb.y - char_speed, @hb.w, @hb.h)
        $WINDOW.current_map.solid_tiles.each do |tile|
          if tile.hb.check_brute_collision(new_hitbox)
            return
          end
        end
        @hb.y -= char_speed
      when GameStates::FaceDir::RIGHT
        new_hitbox = HitBox.new(@hb.x+char_speed, @hb.y, @hb.w, @hb.h)
        $WINDOW.current_map.solid_tiles.each do |tile|
          if tile.hb.check_brute_collision(new_hitbox)
            return
          end
        end
        @hb.x += char_speed
      when GameStates::FaceDir::DOWN
        new_hitbox = HitBox.new(@hb.x, @hb.y + char_speed, @hb.w, @hb.h)
        $WINDOW.current_map.solid_tiles.each do |tile|
          if tile.hb.check_brute_collision(new_hitbox)
            return
          end
        end
        @hb.y += char_speed
      when GameStates::FaceDir::LEFT
        new_hitbox = HitBox.new(@hb.x - char_speed, @hb.y, @hb.w, @hb.h)
        $WINDOW.current_map.solid_tiles.each do |tile|
          if tile.hb.check_brute_collision(new_hitbox)
            return
          end
        end
        @hb.x -= char_speed
    end
  end

  def normal?
    return @state != GameStates::States::RECOILING && @state != GameStates::States::DYING
  end

end