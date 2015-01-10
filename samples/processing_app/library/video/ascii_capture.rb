#
# ASCII Video
# by Ben Fry, translated to ruby-processing by Martin Prout.
#
#
# Text characters have been used to represent images since the earliest computers.
# This sketch is a simple homage that re-interprets live video as ASCII text.
# See the key_pressed function for more options, like changing the font size.
#
load_library :video
include_package 'processing.video'

attr_reader :bright, :char, :cheat_screen, :font, :font_size, :letters, :video

# All ASCII characters, sorted according to their visual density
LETTER_STRING = %q{ .`-_':,;^=+/\"|)\\<>)iv%xclrs{*}I?!][1taeo7zjLunT#JCwfy325Fp6mqSghVd4EgXPGZbYkOA&8U$@KHDBWNMR0Q}
LETTER_ORDER = LETTER_STRING.scan(/./)
def setup
  size(640, 480)
  # This the default video input, see the GettingStartedCapture
  # example if it creates an error
  @video = Capture.new(self, 160, 120)
  # @cheat_screen = true
  # Start capturing the images from the camera
  video.start
  @font_size = 1.5
  @font = load_font(data_path('UniversLTStd-Light-48.vlw'))
  # for the 256 levels of brightness, distribute the letters across
  # the an array of 256 elements to use for the lookup
  @letters = (0...256).map do |i|
    LETTER_ORDER[map1d(i, (0...256), (0...LETTER_ORDER.length))]
  end
  # current brightness for each point
  @bright = Array.new(video.width * video.height, 128)
end

def capture_event(c)
  c.read
  background 0
end

def draw
  return unless (video.available == true)
  capture_event(video)
  push_matrix
  hgap = width / video.width
  vgap = height / video.height
  scale([hgap, vgap].max * font_size)
  text_font(font, font_size)
  index = 0
  video.load_pixels
  (0...video.height).each do
    # Move down for next line
    translate(0,  1.0 / font_size)
    push_matrix
    (0...video.width).each do
      pixel_color = video.pixels[index]
      # Faster method of calculating r, g, b than red(), green(), blue()
      r = pixel_color >> 16 & 0xff
      g = pixel_color >> 8 & 0xff
      b = pixel_color & 0xff
      # Another option would be to properly calculate brightness as luminance:
      # luminance = 0.3*red + 0.59*green + 0.11*blue
      # Or you could instead red + green + blue, and make the the values[] array
      # 256*3 elements long instead of just 256.
      pixel_bright = [r, g, b].max
      # The 0.1 value is used to damp the changes so that letters flicker less
      diff = pixel_bright - bright[index]
      bright[index] += diff * 0.1
      fill(pixel_color)
      text(letters[bright[index]], 0, 0)
      # Move to the next pixel
      index += 1
      # Move over for next character
      translate(1.0 / font_size, 0)
    end
    pop_matrix
  end
  pop_matrix
  if cheat_screen
    # image(video, 0, height - video.height)
    # set() is faster than image() when drawing untransformed images
    set(0, height, video)
  end
end

#
# Handle key presses:
# 'c' toggles the cheat screen that shows the original image in the corner
# 'g' grabs an image and saves the frame to a tiff image
# 'f' and 'F' increase and decrease the font size
#
def key_pressed
  case key
  when 'g'
    save_frame
  when 'c'
    @cheat_screen = !cheat_screen
  when 'f'
    @font_size *= 1.1
  when 'F'
    @font_size *= 0.9
  else
    p 'Controls are g to save_frame, f & F to set font size'
  end
end
