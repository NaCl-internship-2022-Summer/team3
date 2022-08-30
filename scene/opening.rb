module Scene
  class Opening < Scene::Base
    def initialize
      super
    end

    def update
      super
      draw_background
      string = "Space or Enter"
      Window.draw_font(
        Window.width/2 - string.length/2 * Setting::TITLE_FONT_SIZE/2,
        Window.height/2 - Setting::TITLE_FONT_SIZE/2,
        string, Font.new(Setting::TITLE_FONT_SIZE), {color: C_WHITE})
    end

    def next_scene
      Scene::MainGame.new
    end

    def finish?
      # キーコード定数: https://download.eastback.co.jp/dxruby/api/constant_keycode.html
      decide_key = [K_RETURN, K_SPACE]
      decide_key.each do |key|
        return true if Input.key_push?(key)
      end
      false
    end
  end
end