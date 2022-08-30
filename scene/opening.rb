module Scene
  class Opening < Scene::Base
    def initialize
      super

      font = Font.new(32)
      padding = 4
      line_height = 38

      # play button
      text = "click to play"
      w = font.get_width(text) + 10
      @play_button_image = Image.new(w, 40).draw_font(padding, padding, text, font)
      @play_button_image_hover = @play_button_image.clone.line(padding, line_height, w - padding, line_height, C_WHITE)
      @play_button = Button.new((Window.width - @play_button_image.width) / 2, Window.height * 0.7, @play_button_image)

      # exit button
      text = "exit"
      w = font.get_width(text) + 10
      @exit_button_image = Image.new(w, 40).draw_font(padding, padding, text, font)
      @exit_button_image_hover = @exit_button_image.clone.line(padding, line_height, w - padding, line_height, C_WHITE)
      @exit_button = Button.new((Window.width - @exit_button_image.width) / 2, Window.height * 0.8, @exit_button_image)
    end

    def update
      super
      draw_background
      string = "Space or Enter"
      Window.draw_font(
        Window.width/2 - string.length/2 * Setting::TITLE_FONT_SIZE/2,
        Window.height/2 - Setting::TITLE_FONT_SIZE/2,
        string, Font.new(Setting::TITLE_FONT_SIZE), {color: C_WHITE})

      @play_button.image = @play_button.is_hover ? @play_button_image_hover : @play_button_image
      @exit_button.image = @exit_button.is_hover ? @exit_button_image_hover : @exit_button_image
      @play_button.draw
      @exit_button.draw

      if @play_button.is_hover || @exit_button.is_hover
        Input.set_cursor(IDC_HAND)
      else
        Input.set_cursor(IDC_ARROW)
      end
    end

    def next_scene
      Scene::MainGame.new
    end

    def finish?
      # キーコード定数: https://download.eastback.co.jp/dxruby/api/constant_keycode.html

      if @play_button.is_click(M_LBUTTON)
        Input.set_cursor(IDC_ARROW)
        true
      elsif @exit_button.is_click(M_LBUTTON) || Input.key_push?(K_ESCAPE)
        Input.set_cursor(IDC_ARROW)
        Window.close
      else
        false
      end
    end
  end
end