require '../../src/obj/map/tile'
require '../../src/obj/map/map objects/bush'
require '../obj/chars/bat'
class MainMap
  TILE_WIDTH = 12
  TILE_HEIGHT = 12
  TOTAL_HEIGHT = 800
  TOTAL_WIDTH = 800
  attr_accessor :solid_tiles, :enemies, :solid_game_objects, :bushes, :drops

  def initialize
    @solid_tiles = []
    @solid_game_objects = []
    @inactive_enemies = []
    @bushes = []
    @enemies = []
    @drops = []
    wolf1 = Wolf.new(120,120)
    wolf2 = Wolf.new(120,90)
    bat1 = Bat.new(80,120)
    #@enemies << wolf1 << wolf2
    @inactive_enemies << bat1
    #@solid_game_objects << wolf1 << wolf2
  end

  def draw
    @bg.draw(1, 1, 1)
    @enemies.each do |enemy|
      enemy.draw
    end
    @bushes.each do |bush|
      bush.draw
    end
    @drops.each do |drop|
      drop.draw
    end
    if $WINDOW.draw_hb
      @solid_tiles.each do |tile|
        tile.draw
      end
    end
  end

  def update
    if $WINDOW.global_frame_counter == 50
      to_add = []
      to_remove = []
      @inactive_enemies.each do |inen|
        if Gosu.distance($WINDOW.player.hb.x,$WINDOW.player.hb.y,inen.hb.x,inen.hb.y) < 300
          to_add << inen
          @inactive_enemies.delete(inen)
        end
      end
      @enemies.each do |inen|
        if Gosu.distance($WINDOW.player.hb.x,$WINDOW.player.hb.y,inen.hb.x,inen.hb.y) > 300
          to_remove << inen
          @enemies.delete(inen)
        end
      end
      to_add.each do |toadd|
        @enemies << toadd
      end
      to_remove.each do |tremove|
        @inactive_enemies << tremove
      end
    end
    @enemies.each do |enemy|
      enemy.update
    end
    @bushes.each do |bush|
      bush.update
    end
    @drops.each do |drop|
      drop.update unless drop.idle?
    end
  end

  def remove_from_game(obj)
    if obj.is_a?(Char)
      @enemies.delete_if{|enemy| enemy.id == obj.id}
    elsif obj.is_a?(Bush)
      @bushes.delete(obj)
    elsif obj.is_a?(HeartDrop)
      @drops.delete(obj)
    end
    @solid_game_objects.delete_if{|object| object.id == obj.id}
  end

  def set_indices
    @solid_game_objects.each_with_index do |go, index|
      go.id = index unless index == 1
    end
  end

  def draw_bg
    map_sprites = Gosu::Image.load_tiles("../../assets/sprites/Mapas/forest_floor_tiles.png", TILE_WIDTH, TILE_HEIGHT, retro: true)
    plain_d = map_sprites[0]
    flowers = map_sprites[1]
    stone = map_sprites[2]
    plain = map_sprites[3]
    hwall1 = map_sprites[4]
    hwall2 = map_sprites[5]
    walldt = map_sprites[6]
    walldb = map_sprites[7]
    vwall1 = map_sprites[8]
    vwall2 = map_sprites[9]
    bRwallc = map_sprites[10]
    vwallr1 = map_sprites[11]
    vwallr2 = map_sprites[12]
    plain_s = map_sprites[13]
    walldtr = map_sprites[14]
    walldbr = map_sprites[15]
    dirt1 = map_sprites[16]
    dirt2 = map_sprites[17]
    dirtB1 = map_sprites[18]
    dirtB2 = map_sprites[19]
    dirtT1 = map_sprites[20]
    dirtT2 = map_sprites[21]
    bRdirtc = map_sprites[22]
    lBdirtc = map_sprites[23]
    tRdirtc = map_sprites[24]
    lTdirtc = map_sprites[25]
    dirtR1 = map_sprites[26]
    dirtR2 = map_sprites[27]
    dirtL1 = map_sprites[28]
    dirtL2 = map_sprites[29]
    lBwallc = map_sprites[30]
    lBwallc = map_sprites[30]
    thedge1 = map_sprites[31]
    thedge2 = map_sprites[32]
    lhedge1 = map_sprites[33]
    lhedge2 = map_sprites[34]
    rhedge1 = map_sprites[35]
    rhedge2 = map_sprites[36]
    bhedge1 = map_sprites[37]
    bhedge2 = map_sprites[38]
    bRhedgec = map_sprites[39]
    lBhedgec = map_sprites[40]
    tRhedgec = map_sprites[41]
    lThedgec = map_sprites[42]
    underbrush1 = map_sprites[43]
    underbrush2 = map_sprites[44]

    hedge_tree1_1 = map_sprites[48]
    hedge_tree1_2 = map_sprites[49]
    hedge_tree1_3 = map_sprites[56]
    hedge_tree1_4 = map_sprites[57]

    hedge_tree2_1 = map_sprites[54]
    hedge_tree2_2 = map_sprites[55]
    hedge_tree2_3 = map_sprites[62]
    hedge_tree2_4 = map_sprites[63]

    bush          = map_sprites[45]

    f = File.open("../../src/obj/map/map1_layout.txt")
    @bg = Gosu.record(600, 600) {
      f.each_with_index do |line, y|
        line.split(",").each_with_index do |n, x|
          solid = false
          case n
            when '1'
              sprite_to_set = plain
            when '2'
              sprite_to_set = plain_d
            when '3'
              sprite_to_set = plain_s
            when '4'
              sprite_to_set = stone
              solid = true
            when '5'
              sprite_to_set = flowers
            when '6'
              sprite_to_set = dirt1
            when '7'
              sprite_to_set = dirt2
            when '8'
              sprite_to_set = bRdirtc
            when '9'
              sprite_to_set = lBdirtc
            when 'a'
              sprite_to_set = tRdirtc
            when 'b'
              sprite_to_set = lTdirtc
            when 'c'
              sprite_to_set = dirtB1
            when 'd'
              sprite_to_set = dirtB2
            when 'e'
              sprite_to_set = dirtT1
            when 'f'
              sprite_to_set = dirtT2
            when 'g'
              sprite_to_set = dirtL1
            when 'h'
              sprite_to_set = dirtL2
            when 'i'
              sprite_to_set = dirtR1
            when 'j'
              sprite_to_set = dirtR2
            when 'k'
              sprite_to_set = hwall1
              solid = true
            when 'l'
              sprite_to_set = hwall2
              solid = true
            when 'm'
              sprite_to_set = vwall1
              solid = true
            when 'n'
              sprite_to_set = vwall2
              solid = true
            when 'o'
              sprite_to_set = bRwallc
              solid = true
            when 'p'
              sprite_to_set = lBwallc
              solid = true
            when 'q'
              sprite_to_set = vwallr1
              solid = true
            when 'r'
              sprite_to_set = vwallr2
              solid = true
            when 's'
              sprite_to_set = walldt
            when 't'
              sprite_to_set = walldb
            when 'u'
              sprite_to_set = walldtr
            when 'v'
              sprite_to_set = walldbr
            when 'w'
              sprite_to_set = thedge1
              solid = true
            when 'x'
              sprite_to_set = thedge2
              solid = true
            when 'y'
              sprite_to_set = lhedge1
              solid = true
            when 'z'
              sprite_to_set = lhedge2
              solid = true
            when 'A'
              sprite_to_set = rhedge1
              solid = true
            when 'B'
              sprite_to_set = rhedge2
              solid = true
            when 'C'
              sprite_to_set = bhedge1
              solid = true
            when 'D'
              sprite_to_set = bhedge2
              solid = true
            when 'E'
              sprite_to_set = bRhedgec
              solid = true
            when 'F'
              sprite_to_set = lBhedgec
              solid = true
            when 'G'
              sprite_to_set = tRhedgec
              solid = true
            when 'H'
              sprite_to_set = lThedgec
              solid = true
            when 'I'
              sprite_to_set = underbrush1
            when 'J'
              sprite_to_set = underbrush2
            when 'K'
              sprite_to_set = hedge_tree1_1
            when 'L'
              sprite_to_set = hedge_tree1_2
            when 'M'
              sprite_to_set = hedge_tree1_3
            when 'N'
              sprite_to_set = hedge_tree1_4
            when 'O'
              sprite_to_set = hedge_tree2_1
            when 'P'
              sprite_to_set = hedge_tree2_2
            when 'Q'
              sprite_to_set = hedge_tree2_3
            when 'R'
              sprite_to_set = hedge_tree2_4
            when '?'
              puts "there's a bush"
              sprite_to_set = bush
              @bushes << Bush.new(x*TILE_WIDTH, y*TILE_HEIGHT)
          end
          if !sprite_to_set.nil?
            sprite_to_set.draw(x*TILE_WIDTH, y*TILE_HEIGHT, 1)
            if solid
              solid_tile = Tile.new(x*TILE_WIDTH, y*TILE_HEIGHT, TILE_WIDTH, TILE_HEIGHT)
              @solid_tiles  << solid_tile
              @solid_game_objects << solid_tile
            end


          end
        end
      end
    }
  end
end