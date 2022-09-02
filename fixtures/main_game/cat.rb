module Fixture::MainGame
  class Cat < Sprite
    def initialize(x, y, image)
      self.x, self.y, self.image = x, y, image
      @dx = 4
      @dy = 4

      @direction = 0
    end

    def update(interiors)
      self.x += @dx

      if self.x < 0
        self.x = 0
        @dx = - @dx
      elsif self.x + self.image.width > Window.width
        self.x = Window.width - self.image.width
        @dx = - @dx
      elsif self === interiors
        self.x -= @dx
        @dx = - @dx
      end

      self.y += @dy

      if self.y < 0
        self.y = 0
        @dy = - @dy
      elsif self.y + self.image.height > Window.height
        self.y = Window.height - self.image.height
        @dy = - @dy
      elsif self === interiors
        self.y -= @dy
        @dy = - @dy
      end
    end
  end
end
