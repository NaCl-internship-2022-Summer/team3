module Fixture::MainGame
  class Cat < Sprite
    def initialize(x, y, image)
      self.x, self.y, self.image = x, y, image
      @dx = 4
      @dy = 4
    end

    def update
      self.x += @dx
      self.y += @dy

      if self.x < 0
        self.x = 0
        @dx = - @dx
      elsif self.x + self.image.width > Window.width
        self.x = Window.width - self.image.width
        @dx = - @dx
      end

      if self.y < 0
        self.y = 0
        @dy = - @dy
      elsif self.y + self.image.height > Window.height
        self.y = Window.height - self.image.height
        @dy = - @dy
      end
    end

    def hit
      @dy = - @dy
    end
  end
end
