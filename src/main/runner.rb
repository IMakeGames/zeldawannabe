require_relative 'my_window'

$FPS = 60
$CURRENT_MAP = nil
$DRAW_HB = true
$COLOR_RED = Gosu::Color.argb(0xff_ff0000)
$COLOR_BLUE = Gosu::Color.argb(0xff_0000ff)
$COLOR_YELLOW = Gosu::Color.argb(0xff_ffff00)
$map_offsetx = 0
$map_offsety = 0
$WINDOW_HEIGHT = 600
$WINDOW_WIDTH = 800

window = MyWindow.new
window.show
