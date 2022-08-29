module Fixture::MainGame
  class Player < Sprite
    def initialize(x, y)
      # self.x, self.y: Spriteを親に持つPlayerはattr_accessorで定義されたx, yを持つ

      # self:      Playerクラスから作られたインスタンスである自分
      # self.変数: selfの持つ変数を呼び出す (その処理はgetter/setterを呼び出す)
      # @変数:     インスタンス変数 (privateで参照可能な変数)

      self.x = x
      self.y = y
      self.image = Image.load("images/videographer.png")
      self.image.set_color_key(C_WHITE)
    end

    def update
      self.x = Input.mouse_x
      if self.x < 0
        self.x = 0
      elsif self.x > (Window.width - self.image.width)
        self.x = (Window.width - self.image.width)
      end
      self.y = Input.mouse_y
      if self.y < 0
        self.y = 0
      elsif self.y > (Window.height - self.image.height)
        self.y = (Window.height - self.image.height)
      end
    end
  end
end
