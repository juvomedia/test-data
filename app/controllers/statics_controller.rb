class StaticsController < ApplicationController
  def index
    @images = Hash[*([
      ['test_1.png', "Alt text for test image #1 - PNG "],
      ['test_2.gif', "Alt text for test image #2 - GIF "],
      ['test_3.jpg', "Alt text for test image #3 - JPG "],
      ['test_4.jpg', "Alt text for test image #4 - JPG "]
    ].shuffle.flatten)]
  end
end
