require '../../src/obj/map/map_tile'
class MainMap

  def initialize
      @map_sprites = Gosu::Image.load_tiles("../../assets/sprites/Mapas/forest_floor_tiles.png", 12, 12, retro: true)
      @plain_d            = MapTile.new(@map_sprites[0])
      @flowers            = MapTile.new(@map_sprites[1])
      @stone              = MapTile.new(@map_sprites[2])
      @plain              = MapTile.new(@map_sprites[3])
      @hwall1              = MapTile.new(@map_sprites[4])
      @hwall2              = MapTile.new(@map_sprites[5])
      @walldt             = MapTile.new(@map_sprites[6])
      @walldb             = MapTile.new(@map_sprites[7])
      @vwall1             = MapTile.new(@map_sprites[8])
      @vwall2             = MapTile.new(@map_sprites[9])
      @BRwallc             = MapTile.new(@map_sprites[10])
      @vwallr1             = MapTile.new(@map_sprites[11])
      @vwallr2             = MapTile.new(@map_sprites[12])
      @plain_s             = MapTile.new(@map_sprites[13])
      @walldtr             = MapTile.new(@map_sprites[14])
      @walldbr             = MapTile.new(@map_sprites[15])
      @dirt1             = MapTile.new(@map_sprites[16])
      @dirt2             = MapTile.new(@map_sprites[17])
      @dirtB1             = MapTile.new(@map_sprites[18])
      @dirtB2             = MapTile.new(@map_sprites[19])
      @dirtT1             = MapTile.new(@map_sprites[20])
      @dirtT2             = MapTile.new(@map_sprites[21])
      @BRdirtc             = MapTile.new(@map_sprites[22])
      @LBdirtc           = MapTile.new(@map_sprites[23])
      @TRdirtc             = MapTile.new(@map_sprites[24])
      @LTdirtc           = MapTile.new(@map_sprites[25])
      @dirtR1             = MapTile.new(@map_sprites[26])
      @dirtR2             = MapTile.new(@map_sprites[27])
      @dirtL1             = MapTile.new(@map_sprites[28])
      @dirtL2             = MapTile.new(@map_sprites[29])
      @LBwallc             = MapTile.new(@map_sprites[30])
      @LBwallc             = MapTile.new(@map_sprites[30])
      @Thedge1              = MapTile.new (@map_sprites[31])
      @Thedge2              = MapTile.new (@map_sprites[32])
      @Lhedge1              = MapTile.new (@map_sprites[33])
      @Lhedge2              = MapTile.new (@map_sprites[34])
      @Rhedge1              = MapTile.new (@map_sprites[35])
      @Rhedge2              = MapTile.new (@map_sprites[36])
      @Bhedge1              = MapTile.new (@map_sprites[37])
      @Bhedge2              = MapTile.new (@map_sprites[38])
      @BRhedgec             = MapTile.new (@map_sprites[39])
      @LBhedgec             = MapTile.new (@map_sprites[40])
      @TRhedgec             = MapTile.new (@map_sprites[41])
      @LThedgec             = MapTile.new (@map_sprites[42])
      @underbrush1             = MapTile.new (@map_sprites[43])
      @underbrush2             = MapTile.new (@map_sprites[44])

      @tree1             = MapTile.new (@map_sprites[48])
      @tree2             = MapTile.new (@map_sprites[49])
      @tree3             = MapTile.new (@map_sprites[56])
      @tree4             = MapTile.new (@map_sprites[57])



      @map_tiles = []

      f = File.open("../../src/obj/map/map1_layout.txt")
      f.each do |line|
        @line = []
        line.split(",").each do |n|
          case n
            when '1'
              @line << @plain
            when '2'
              @line << @plain_d
            when '3'
              @line << @plain_s
            when '4'
              @line << @stone
            when '5'
              @line << @flowers
            when '6'
              @line << @dirt1
            when '7'
              @line << @dirt2
            when '8'
              @line << @BRdirtc
            when '9'
              @line << @LBdirtc
            when 'a'
              @line << @TRdirtc
            when 'b'
              @line << @LTdirtc
            when 'c'
              @line << @dirtB1
            when 'd'
              @line << @dirtB2
            when 'e'
              @line << @dirtT1
            when 'f'
              @line << @dirtT2
            when 'g'
              @line << @dirtL1
            when 'h'
              @line << @dirtL2
            when 'i'
              @line << @dirtR1
            when 'j'
              @line << @dirtR2
            when 'k'
              @line << @hwall1
            when 'l'
              @line << @hwall2
            when 'm'
              @line << @vwall1
            when 'n'
              @line << @vwall2
            when 'o'
              @line << @BRwallc
            when 'p'
              @line << @LBwallc
            when 'q'
              @line << @vwallr1
            when 'r'
              @line << @vwallr2
            when 's'
              @line << @walldt
            when 't'
              @line << @walldb
            when 'u'
              @line << @walldtr
            when 'v'
              @line << @walldbr
            when 'w'
              @line << @Thedge1
            when 'x'
              @line << @Thedge2
            when 'y'
              @line << @Lhedge1
            when 'z'
              @line << @Lhedge2
            when 'A'
              @line << @Rhedge1
            when 'B'
              @line << @Rhedge2
            when 'C'
              @line << @Bhedge1
            when 'D'
              @line << @Bhedge2
            when 'E'
              @line << @BRhedgec
            when 'F'
              @line << @LBhedgec
            when 'G'
              @line << @TRhedgec
            when 'H'
              @line << @LThedgec
            when 'I'
              @line << @underbrush1
            when 'J'
              @line << @underbrush2
            when 'K'
              @line << @tree1
            when 'L'
              @line << @tree2
            when 'M'
              @line << @tree3
            when 'N'
              @line << @tree4
          end
        end
        @map_tiles << @line
      end
  end

  def draw
    @map_tiles.each_with_index do |arr, ind1|
      arr.each_with_index do |obj, ind2|
        obj.img.draw(ind2*12,ind1*12,1)
      end
    end
  end


end