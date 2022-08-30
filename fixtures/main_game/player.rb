module Fixture::MainGame
  class Player < Sprite
    attr_reader :direction

    def initialize(x, y)
      # self.x, self.y: Spriteを親に持つPlayerはattr_accessorで定義されたx, yを持つ

      # self:      Playerクラスから作られたインスタンスである自分
      # self.変数: selfの持つ変数を呼び出す (その処理はgetter/setterを呼び出す)
      # @変数:     インスタンス変数 (privateで参照可能な変数)

      @right_player = Image.load("images/right_videographer.png")
      @left_player = Image.load("images/left_videographer.png")

      self.x = x
      self.y = y
      self.image = @right_player
      self.image.set_color_key(C_WHITE)
      self.center_x = 40
      self.center_y = 34
      self.image.circle_fill(self.center_x, self.center_y, 5, C_BLACK)
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

      center_x = self.x + self.image.width / 2
      center_y = self.y + self.image.height / 2
      mouse_pos_x = Input.mouse_x - center_x
      mouse_pos_y = Input.mouse_y - center_y
      radian = Math.atan2(mouse_pos_y, mouse_pos_x)
      @direction = 180 / Math::PI * radian

      if center_x < Input.mouse_x
        self.image = @right_player
      else
        self.image = @left_player
      end
    end
  end
end
