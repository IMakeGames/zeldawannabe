require '../../src/obj/map/map_tile'
class MainMap
  TILE_WIDTH = 12
  TILE_HEIGHT = 12
  attr_accessor :solid_tiles

  def initialize
    @map_sprites = Gosu::Image.load_tiles("../../assets/sprites/Mapas/forest_floor_tiles.png", TILE_WIDTH, TILE_HEIGHT, retro: true)
    @plain_d = @map_sprites[0]
    @flowers = @map_sprites[1]
    @stone = @map_sprites[2]
    @plain = @map_sprites[3]
    @hwall1 = @map_sprites[4]
    @hwall2 = @map_sprites[5]
    @walldt = @map_sprites[6]
    @walldb = @map_sprites[7]
    @vwall1 = @map_sprites[8]
    @vwall2 = @map_sprites[9]
    @BRwallc = @map_sprites[10]
    @vwallr1 = @map_sprites[11]
    @vwallr2 = @map_sprites[12]
    @plain_s = @map_sprites[13]
    @walldtr = @map_sprites[14]
    @walldbr = @map_sprites[15]
    @dirt1 = @map_sprites[16]
    @dirt2 = @map_sprites[17]
    @dirtB1 = @map_sprites[18]
    @dirtB2 = @map_sprites[19]
    @dirtT1 = @map_sprites[20]
    @dirtT2 = @map_sprites[21]
    @BRdirtc = @map_sprites[22]
    @LBdirtc = @map_sprites[23]
    @TRdirtc = @map_sprites[24]
    @LTdirtc = @map_sprites[25]
    @dirtR1 = @map_sprites[26]
    @dirtR2 = @map_sprites[27]
    @dirtL1 = @map_sprites[28]
    @dirtL2 = @map_sprites[29]
    @LBwallc = @map_sprites[30]
    @LBwallc = @map_sprites[30]
    @Thedge1 = @map_sprites[31]
    @Thedge2 = @map_sprites[32]
    @Lhedge1 = @map_sprites[33]
    @Lhedge2 = @map_sprites[34]
    @Rhedge1 = @map_sprites[35]
    @Rhedge2 = @map_sprites[36]
    @Bhedge1 = @map_sprites[37]
    @Bhedge2 = @map_sprites[38]
    @BRhedgec = @map_sprites[39]
    @LBhedgec = @map_sprites[40]
    @TRhedgec = @map_sprites[41]
    @LThedgec = @map_sprites[42]
    @underbrush1 = @map_sprites[43]
    @underbrush2 = @map_sprites[44]

    @tree1 = @map_sprites[48]
    @tree2 = @map_sprites[49]
    @tree3 = @map_sprites[56]
    @tree4 = @map_sprites[57]


    @map_tiles = []
    @solid_tiles = []

    f = File.open("../../src/obj/map/map1_layout.txt")
    f.each_with_index do |line, y|
      @line = []
      line.split(",").each_with_index do |n, x|
        solid = false
        case n
          when '1'
            sprite_to_set = @plain
          when '2'
            sprite_to_set = @plain_d
          when '3'
            sprite_to_set = @plain_s
          when '4'
            sprite_to_set = @stone
            solid = true
          when '5'
            sprite_to_set = @flowers
          when '6'
            sprite_to_set = @dirt1
          when '7'
            sprite_to_set = @dirt2
          when '8'
            sprite_to_set = @BRdirtc
          when '9'
            sprite_to_set = @LBdirtc
          when 'a'
            sprite_to_set = @TRdirtc
          when 'b'
            sprite_to_set = @LTdirtc
          when 'c'
            sprite_to_set = @dirtB1
          when 'd'
            sprite_to_set = @dirtB2
          when 'e'
            sprite_to_set = @dirtT1
          when 'f'
            sprite_to_set = @dirtT2
          when 'g'
            sprite_to_set = @dirtL1
          when 'h'
            sprite_to_set = @dirtL2
          when 'i'
            sprite_to_set = @dirtR1
          when 'j'
            sprite_to_set = @dirtR2
          when 'k'
            sprite_to_set = @hwall1
            solid = true
          when 'l'
            sprite_to_set = @hwall2
            solid = true
          when 'm'
            sprite_to_set = @vwall1
            solid = true
          when 'n'
            sprite_to_set = @vwall2
            solid = true
          when 'o'
            sprite_to_set = @BRwallc
            solid = true
          when 'p'
            sprite_to_set = @LBwallc
            solid = true
          when 'q'
            sprite_to_set = @vwallr1
            solid = true
          when 'r'
            sprite_to_set = @vwallr2
            solid = true
          when 's'
            sprite_to_set = @walldt
          when 't'
            sprite_to_set = @walldb
          when 'u'
            sprite_to_set = @walldtr
          when 'v'
            sprite_to_set = @walldbr
          when 'w'
            sprite_to_set = @Thedge1
            solid = true
          when 'x'
            sprite_to_set = @Thedge2
            solid = true
          when 'y'
            sprite_to_set = @Lhedge1
            solid = true
          when 'z'
            sprite_to_set = @Lhedge2
            solid = true
          when 'A'
            sprite_to_set = @Rhedge1
            solid = true
          when 'B'
            sprite_to_set = @Rhedge2
            solid = true
          when 'C'
            sprite_to_set = @Bhedge1
            solid = true
          when 'D'
            sprite_to_set = @Bhedge2
            solid = true
          when 'E'
            sprite_to_set = @BRhedgec
            solid = true
          when 'F'
            sprite_to_set = @LBhedgec
            solid = true
          when 'G'
            sprite_to_set = @TRhedgec
            solid = true
          when 'H'
            sprite_to_set = @LThedgec
            solid = true
          when 'I'
            sprite_to_set = @underbrush1
          when 'J'
            sprite_to_set = @underbrush2
          when 'K'
            sprite_to_set = @tree1
          when 'L'
            sprite_to_set = @tree2
          when 'M'
            sprite_to_set = @tree3
          when 'N'
            sprite_to_set = @tree4
        end
        if !sprite_to_set.nil?
          new_tile = MapTile.new(sprite_to_set, x*TILE_WIDTH, y*TILE_HEIGHT, TILE_WIDTH, TILE_HEIGHT, solid)
          @line << new_tile
          if solid
            @solid_tiles << new_tile
          end
        end
      end
      @map_tiles << @line
    end
  end

  def draw
    @map_tiles.each do |arr|
      arr.each do |obj|
        obj.draw
      end
    end
  end

end