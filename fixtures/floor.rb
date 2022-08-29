module Fixture
  class Floor
    def initialize
      @tiles = []
      tile_width_range = (50..80)
      tile_height = 20
      colors = [
        [141, 99, 75], #8D634B
        [146, 103, 78], #92674E
        [159, 114, 89] #9F7259
      ]
      x = 0
      y = 0
      loop do
        w = rand(tile_width_range) / 10 * 10
        @tiles << Sprite.new(x, y, Image.new(w, tile_height, colors[rand(colors.length)]))
        x += w
        if x > Window.width
          x = 0
          y += tile_height
          break if y > Window.height
        end
      end
    end

    def draw
      Sprite.draw(@tiles)
    end
  end
end
