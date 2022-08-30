module Fixture::MainGame
  class Interior < Sprite
    def initialize(x, y, image)
      self.x, self.y, self.image = x, y, image
    end

    def update
      self.x = [0, [self.x, Window.width - self.image.width].min].max
      self.y = [0, [self.y, Window.height - self.image.height].min].max
    end
  end
end
