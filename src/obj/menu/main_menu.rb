class MainMenu

  def initialize
    @bg = Gosu::Image.new("#{Dir.pwd}/assets/sprites/Interface/menu_as_should_be.png", retro: true)
  end

  def draw
    @bg.draw(0, 0, 1)
    writer = Writer.new
    writer.draw_text(10, 5, "Hello There\nLetñs suppose that\nI can write two lines\nor three")
  end

  def update

  end

  class Writer
    def initialize
      @fonts = Gosu::Image.load_tiles("#{Dir.pwd}/assets/sprites/Interface/real_font.png", 9, 11, retro: true)
    end

    def draw_text(x, y, text)
      linea = 0
      text.each_line do |line|
        draw_in_x = x
        next_x = 0
        line.each_char do |char|
          case char
            when 'A'
              next_x = draw_in_x + 8
              letter@fonts[0]
            when 'B'
              next_x = draw_in_x + 8
              letter = @fonts[1]
            when 'C'
              next_x = draw_in_x + 8
              letter = @fonts[2]
            when 'D'
              next_x = draw_in_x + 8
              letter = @fonts[3]
            when 'E'
              next_x = draw_in_x + 8
              letter = @fonts[4]
            when 'F'
              next_x = draw_in_x + 8
              letter = @fonts[5]
            when 'G'
              next_x = draw_in_x + 8
              letter = @fonts[6]
            when 'H'
              next_x = draw_in_x + 8
              letter = @fonts[7]
            when 'I'
              next_x = draw_in_x + 5
              letter = @fonts[8]
            when 'J'
              next_x = draw_in_x + 6
              letter = @fonts[9]
            when 'K'
              next_x = draw_in_x + 8
              letter = @fonts[10]
            when 'L'
              next_x = draw_in_x + 7
              letter = @fonts[11]
            when 'M'
              next_x = draw_in_x + 8
              letter = @fonts[12]
            when 'N'
              next_x = draw_in_x + 8
              letter = @fonts[13]
            when 'O'
              next_x = draw_in_x + 8
              letter = @fonts[14]
            when 'P'
              next_x = draw_in_x + 8
              letter = @fonts[15]
            when 'Q'
              next_x = draw_in_x + 8
              letter = @fonts[16]
            when 'R'
              next_x = draw_in_x + 8
              letter = @fonts[17]
            when 'S'
              next_x = draw_in_x + 8
              letter = @fonts[18]
            when 'T'
              next_x = draw_in_x + 7
              letter = @fonts[19]
            when 'U'
              next_x = draw_in_x + 8
              letter = @fonts[20]
            when 'V'
              next_x = draw_in_x + 8
              letter = @fonts[21]
            when 'W'
              next_x = draw_in_x + 8
              letter = @fonts[22]
            when 'x'
              next_x = draw_in_x + 8
              letter = @fonts[23]
            when 'Y'
              next_x = draw_in_x + 8
              letter = @fonts[24]
            when 'Z'
              next_x = draw_in_x + 8
              letter = @fonts[25]
            when 'a'
              next_x = draw_in_x + 8
              letter = @fonts[26]
            when 'b'
              next_x = draw_in_x + 8
              letter = @fonts[27]
            when 'c'
              next_x = draw_in_x + 8
              letter = @fonts[28]
            when 'd'
              next_x = draw_in_x + 8
              letter = @fonts[29]
            when 'e'
              next_x = draw_in_x + 7
              letter = @fonts[30]
            when 'f'
              next_x = draw_in_x + 6
              letter = @fonts[31]
            when 'g'
              next_x = draw_in_x + 8
              letter = @fonts[32]
            when 'h'
              next_x = draw_in_x + 8
              letter = @fonts[33]
            when 'i'
              next_x = draw_in_x + 5
              letter = @fonts[34]
            when 'j'
              next_x = draw_in_x + 6
              letter = @fonts[35]
            when 'k'
              next_x = draw_in_x + 8
              letter = @fonts[36]
            when 'l'
              next_x = draw_in_x + 6
              letter = @fonts[37]
            when 'm'
              next_x = draw_in_x + 8
              letter = @fonts[38]
            when 'n'
              next_x = draw_in_x + 8
              letter = @fonts[39]
            when 'o'
              next_x = draw_in_x + 8
              letter = @fonts[40]
            when 'p'
              next_x = draw_in_x + 8
              letter = @fonts[41]
            when 'q'
              next_x = draw_in_x + 8
              letter = @fonts[42]
            when 'r'
              next_x = draw_in_x + 8
              letter = @fonts[43]
            when 's'
              next_x = draw_in_x + 8
              letter = @fonts[44]
            when 't'
              next_x = draw_in_x + 6
              letter = @fonts[45]
            when 'u'
              next_x = draw_in_x + 8
              letter = @fonts[46]
            when 'v'
              next_x = draw_in_x + 8
              letter = @fonts[47]
            when 'w'
              next_x = draw_in_x + 8
              letter = @fonts[48]
            when 'x'
              next_x = draw_in_x + 8
              letter = @fonts[49]
            when 'y'
              next_x = draw_in_x + 8
              letter = @fonts[50]
            when 'z'
              next_x = draw_in_x + 8
              letter = @fonts[51]
            when '0'
              next_x = draw_in_x + 8
              letter = @fonts[52]
            when '1'
              next_x = draw_in_x + 5
              letter = @fonts[53]
            when '2'
              next_x = draw_in_x + 7
              letter = @fonts[54]
            when '3'
              next_x = draw_in_x + 7
              letter = @fonts[55]
            when '4'
              next_x = draw_in_x + 7
              letter = @fonts[56]
            when '5'
              next_x = draw_in_x + 7
              letter = @fonts[57]
            when '6'
              next_x = draw_in_x + 7
              letter = @fonts[58]
            when '7'
              next_x = draw_in_x + 7
              letter = @fonts[59]
            when '8'
              next_x = draw_in_x + 7
              letter = @fonts[60]
            when '9'
              next_x = draw_in_x + 7
              letter = @fonts[61]
            when '!'
              next_x = draw_in_x + 6
              letter = @fonts[62]
            when '?'
              next_x = draw_in_x + 7
              letter = @fonts[63]
            when '#'
              next_x = draw_in_x + 7
              letter = @fonts[64]
            when 'ñ'
              next_x = draw_in_x + 4
              letter = @fonts[65]
            when ' '
              next_x = draw_in_x + 6
              letter = @fonts[66]
          end
          letter.draw(draw_in_x, y+11*linea, 10) unless letter == nil
          draw_in_x = next_x
        end
        linea += 1
      end
    end

  end

end
