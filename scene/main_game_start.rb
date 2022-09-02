module Scene
  class MainGameStart < Scene::Base
    def initialize
      super

      @next = Scene::MainGame.new
    end

    def update
      super
    end

    def draw
      @next.draw
      Window.draw(0, 0, Image.new(Window.width, Window.height, [100, 0, 0, 0]))
    end

    def next_scene
      @next
    end

    def finish?
      # キーコード定数: https://download.eastback.co.jp/dxruby/api/constant_keycode.html
      quit_key = [K_ESCAPE]
      quit_key.each do |key|
        return true if Input.key_push?(key)
      end
      false
    end
  end
end
