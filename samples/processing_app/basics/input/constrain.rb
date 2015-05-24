# Move the mouse across the screen to move the circle.
# The program constrains the circle to its box.
# You can still use processing constrain if you wish, but
# since it is implemented using ruby-processing 'clip to range'
# method we prefer that here...
attr_reader :inner, :easing, :edge, :ellipse_size, :mx, :my

def setup
  size 640, 360
  no_stroke
  ellipse_mode RADIUS
  rect_mode CORNERS
  @mx, @my = 0.0, 0.0
  @easing = 0.05
  @ellipse_size = 24.0
  @edge = 100
  @inner = edge + ellipse_size
end

def draw
  background 51
  @mx += (mouse_x - mx) * easing if (mouse_x - mx).abs > 0.1
  @my += (mouse_y - my) * easing if (mouse_y - my).abs > 0.1
  @mx = (inner..(width - inner)).clip mx
  @my = (inner..(height - inner)).clip my
  fill 76
  rect edge, edge, width - edge, height - edge
  fill 255
  ellipse mx, my, ellipse_size, ellipse_size
end
