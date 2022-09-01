module Scene
  class Ending < Scene::Base
    def initialize(score)
      super()
      @score = score
      @font = Font.new(Setting::TITLE_BUTTON_FONT_SIZE, Setting::FONT_JA)
      padding = 4
      line_height = 38
      # タイトルに戻る button
      text = "タイトル画面に戻る"
      w = @font.get_width(text) + 10
      @return_title_button_image = Image.new(w, 40).draw_font_ex(padding, padding, text, @font)
      @return_title_button_image_hover = @return_title_button_image.clone.line(padding, line_height, w - padding, line_height, C_WHITE)
      @return_title_button = Button.new((Window.width - @return_title_button_image.width) / 2, Window.height * 0.85, @return_title_button_image)

    end

    def update
      super
      draw_background
      Window.draw_font(16, 16, "とくてん: #{@score} てん也", @font, {color: C_WHITE})
      # Window.draw_font(
      #   Window.width/2 - 3*Setting::ENDING_FONT_SIZE/2,
      #   Window.height/2 - Setting::ENDING_FONT_SIZE/2,
      #   "おわり", Font.new(Setting::ENDING_FONT_SIZE), {color: C_WHITE})
      @return_title_button.image = @return_title_button.is_hover ? @return_title_button_image_hover : @return_title_button_image
      @return_title_button.draw
    end

    def next_scene
      Scene::Opening.new
    end

    def finish?
      if @return_title_button.is_click(M_LBUTTON)
        Input.set_cursor(IDC_ARROW)
        true
      else
        quit_key = [K_RETURN, K_SPACE, K_ESCAPE]
        quit_key.each do |key|
          return true if Input.key_push?(key)
        end
        false
      end
    end
  end
end
