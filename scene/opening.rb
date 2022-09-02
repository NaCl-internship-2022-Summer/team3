module Scene
  class Opening < Scene::Base
    def initialize
      super

      # sleeping cat
      @sleeping_cat = Sprite.new(10, 100, Image.load("images/_original_cat_sleeping.png"))
      @sleeping_cat.scale_x = 0.5
      @sleeping_cat.scale_y = 0.5
      @sleeping_cat.x = -150
      @sleeping_cat.y = -220

      @title_font = Font.new(Setting::TITLE_FONT_SIZE, Setting::FONT_JA)

      font = Font.new(Setting::TITLE_BUTTON_FONT_SIZE, Setting::FONT_JA)
      padding = 4
      line_height = 38

      # play button
      text = "ゲームをはじめる"
      w = font.get_width(text) + 10
      @play_button_image = Image.new(w, 40).draw_font_ex(padding, padding, text, font)
      @play_button_image_hover = @play_button_image.clone.line(padding, line_height, w - padding, line_height, C_WHITE)
      @play_button = Button.new((Window.width - @play_button_image.width) / 2, Window.height * 0.7, @play_button_image)

      # exit button
      text = "ゲームをおわる"
      w = font.get_width(text) + 10
      @exit_button_image = Image.new(w, 40).draw_font_ex(padding, padding, text, font)
      @exit_button_image_hover = @exit_button_image.clone.line(padding, line_height, w - padding, line_height, C_WHITE)
      @exit_button = Button.new((Window.width - @exit_button_image.width) / 2, Window.height * 0.8, @exit_button_image)

      # 猫の鳴き声
      @meow = Sound.new("sounds/cat_meow.wav")
      @meow.set_volume(200)
    end

    def update
      super
      draw_background

      @sleeping_cat.draw

      title = "バズねこ"
      Window.draw_font_ex(
        (Window.width- @title_font.get_width(title)) / 2,
        Window.height/2,
        title, @title_font, {color: C_WHITE})

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
      Scene::Select.new
    end

    def finish?
      # キーコード定数: https://download.eastback.co.jp/dxruby/api/constant_keycode.html

      if @play_button.is_click(M_LBUTTON)
        Input.set_cursor(IDC_ARROW)
        @meow.play
        true
      elsif @exit_button.is_click(M_LBUTTON) || Input.key_push?(K_ESCAPE)
        Input.set_cursor(IDC_ARROW)
        Window.close
      else
        false
      end
    end

    def restart?
    end
  end
end
