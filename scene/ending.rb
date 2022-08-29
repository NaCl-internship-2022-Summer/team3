module Scene
  class Ending < Scene::Base
    def initialize(score)
      super()
      @score = score
    end

    def update
      super
      draw_background
      Window.draw_font(16, 16, "とくてん: #{@score} てん也", Font.new(Setting::DEFAULT_FONT_SIZE), {color: C_WHITE})
      Window.draw_font(
        Window.width/2 - 3*Setting::ENDING_FONT_SIZE/2,
        Window.height/2 - Setting::ENDING_FONT_SIZE/2,
        "おわり", Font.new(Setting::ENDING_FONT_SIZE), {color: C_WHITE})
    end

    def next_scene
      nil
    end

    def finish?
      # キーコード定数: https://download.eastback.co.jp/dxruby/api/constant_keycode.html
      quit_key = [K_RETURN, K_SPACE, K_ESCAPE]
      quit_key.each do |key|
        return true if Input.key_push?(key)
      end
      false
    end
  end
end