require_relative 'my_window'

$FPS = 45
$CURRENT_MAP = nil
$DRAW_HB = true
$COLOR_RED = Gosu::Color.argb(0xff_ff0000)
$COLOR_BLUE = Gosu::Color.argb(0xff_0000ff)
$COLOR_YELLOW = Gosu::Color.argb(0xff_ffff00)

window = MyWindow.new
window.show
