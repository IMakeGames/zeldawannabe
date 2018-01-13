require '../../src/obj/map/map_tile'
class MainMap

  def initialize
      @map = Gosu::Image.new("../../assets/sprites/Mapas/forest_floor_tiles.png", retro: true)
      @map_sprites = Gosu::Image.load_tiles("../../assets/sprites/Mapas/forest_floor_tiles.png", 12, 12, retro: true)
      @plain_w            = MapTile.new(@map_sprites[0])
      @flowers            = MapTile.new(@map_sprites[1])
      @stone              = MapTile.new(@map_sprites[2])
      @plain              = MapTile.new(@map_sprites[3])
      @hwall1              = MapTile.new(@map_sprites[4])
      @hwall2              = MapTile.new(@map_sprites[5])
      @walldt             = MapTile.new(@map_sprites[6])
      @walldb             = MapTile.new(@map_sprites[7])
      @vwall1             = MapTile.new(@map_sprites[8])
      @vwall2             = MapTile.new(@map_sprites[9])
      @dwallc             = MapTile.new(@map_sprites[10])

      # 1 = plain
      # 2 = plain with dirt
      # 3 = stone
      # 4 = flower
      #
      # 5 = horizontal wall 1
      # 6 = horizontal wall 2
      # 7 = vertical wall 1
      # 8 = vertical wall 2
      # 9 = corner
      #
      # 10 = diagonal wall with bottom grass
      # 11 = diagonal wall with top grass
      @map_tiles = []

      f = File.open("../../src/obj/map/map1_layout.txt")
      f.each do |line|
        @line = []
        line.split(",").each do |n|
          case n.to_i
            when 1
              @line << @plain
            when 2
              @line << @plain_w
            when 3
              @line << @stone
            when 4
              @line << @flowers
            when 5
              @line << @hwall1
            when 6
              @line << @hwall2
            when 7
              @line << @vwall1
            when 8
              @line << @vwall2
            when 9
              @line << @dwallc
            when 10
              @line << @walldt
            when 11
              @line << @walldb
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