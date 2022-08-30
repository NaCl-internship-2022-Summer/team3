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
      if Input.key_down?(K_W) || Input.key_down?(K_UP)
        self.y -= 1
      elsif Input.key_down?(K_A) || Input.key_down?(K_LEFT)
        self.x -= 1
      elsif Input.key_down?(K_S) || Input.key_down?(K_DOWN)
        self.y += 1
      elsif Input.key_down?(K_D) || Input.key_down?(K_RIGHT)
        self.x += 1
      end
      self.x = [0, [self.x, Window.width - self.image.width].min].max
      self.y = [0, [self.y, Window.height - self.image.height].min].max

      mouse_pos_x = Input.mouse_x - self.x
      mouse_pos_y = Input.mouse_y - self.y
      direction = Math.atan2(mouse_pos_y, mouse_pos_x)
      self.angle = direction * 100
    end
  end
end
