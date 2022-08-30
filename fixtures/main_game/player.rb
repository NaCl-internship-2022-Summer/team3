module Fixture::MainGame
  class Player < Sprite
    attr_reader :direction, :cx, :cy

    def initialize(x, y)
      # self.x, self.y: Spriteを親に持つPlayerはattr_accessorで定義されたx, yを持つ

      # self:      Playerクラスから作られたインスタンスである自分
      # self.変数: selfの持つ変数を呼び出す (その処理はgetter/setterを呼び出す)
      # @変数:     インスタンス変数 (privateで参照可能な変数)

      @right_player = Image.load("images/right_videographer.png")
      @left_player = Image.load("images/left_videographer.png")

      self.x, self.y = x, y
      self.image = @right_player
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

      @cx = self.x + self.image.width / 2
      @cy = self.y + self.image.height / 2
      mouse_pos_x = Input.mouse_x - @cx
      mouse_pos_y = Input.mouse_y - @cy
      d = Math.atan2(mouse_pos_y, mouse_pos_x)
      @direction = d < 0 ? d + 2 * Math::PI : d

      if @cx < Input.mouse_x
        self.image = @right_player
      else
        self.image = @left_player
      end
    end

    def shot
      if Input.key_down?(K_W) || Input.key_down?(K_UP)
        self.y += 1
      elsif Input.key_down?(K_A) || Input.key_down?(K_LEFT)
        self.x += 1
      elsif Input.key_down?(K_S) || Input.key_down?(K_DOWN)
        self.y -= 1
      elsif Input.key_down?(K_D) || Input.key_down?(K_RIGHT)
        self.x -= 1
      end
      Window.draw_font(Window.width/2 - 12*Setting::DEFAULT_FONT_SIZE/2,
                       Window.height/2 - Setting::DEFAULT_FONT_SIZE/2,
                       "家具が邪魔で進めないよ！", Font.new(Setting::DEFAULT_FONT_SIZE),
                       {color: C_WHITE})
    end
  end
end
