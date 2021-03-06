# Pointillism
# by Daniel Shiffman.
#
# Mouse horizontal location controls size of dots.
# Creates a simple pointillist effect using ellipses colored
# according to pixels in an image.

def setup
  size 400, 400
  @a = load_image 'eames.jpg'
  no_stroke
  background 255
  smooth
end

def draw
  pointillize = map1d(mouse_x, (0..width), (2..18))
  x, y = rand(@a.width), rand(@a.height)
  pixel = @a.get(x, y)
  fill pixel, 126
  ellipse x * 2, y * 2, pointillize, pointillize
end
