module Scene
  class Select < Scene::Base
    def initialize
      super

      @next_scene = nil
      @title_font = Font.new(Setting::TITLE_FONT_SIZE, Setting::FONT_JA)
      @background = Image.new(Window.width, Window.height, C_WHITE)

      # describe
      @describe_oy = 180
      @describe_font = Font.new(Setting::DESCRIBE_FONT_SIZE, Setting::FONT_JA)

      json = SaveData.load
      @users = json[:users] || []
      @account_button_images = []
      @account_button_images_hover = []
      @account_buttons = []
      font = Font.new(26, Setting::FONT_JA)
      padding = 4
      line_height = 32
      3.times do |i|
        user = @users[i]
        text = (user ? user[:name] : "")
        w = font.get_width(text) + 10
        @account_button_images << Image.new(w, 40).draw_font_ex(padding, padding, text, font, { color: Setting::FONT_COLOR_BLACK })
        @account_button_images_hover << @account_button_images.last
                                                              .clone
                                                              .line(padding, line_height, w - padding, line_height, Setting::FONT_COLOR_BLACK)
        @account_buttons << Button.new(
          (Window.width - @account_button_images.last.width) / 2,
          Window.height * 0.5 + @account_button_images.last.height * i, @account_button_images.last
        )
      end

      # new save data
      font = Font.new(18, Setting::FONT_JA)
      text = "ニューゲーム"
      padding = 15
      w = font.get_width(text) + padding * 2
      h = 50
      @new_user_button_image = RoundedBox.new(w, h, [113, 187, 255], 25)
                                         .draw_font_ex(padding, (h - font.size) / 2, text, font, { color: C_WHITE })
      @new_user_button_image_hover = @new_user_button_image.clone
      @new_user_button = Button.new((Window.width - @new_user_button_image.width) / 2, Window.height * 0.8, @new_user_button_image)
    end

    def update
      super
      Window.draw(0, 0, @background)
      Window.draw_font_ex(40, 50, "ネコったー", @title_font, {color: Setting::FONT_COLOR_BLACK})

      Setting::DESCRIBE_TEXTS.each_with_index do |text, i|
        Window.draw_font_ex(
          (Window.width - @describe_font.get_width(text)) / 2,
          @describe_oy + @describe_font.size * i,
          text,
          @describe_font,
          {color: Setting::FONT_COLOR_BLACK}
        )
      end

      @account_buttons.each_with_index do |btn, i|
        btn.image = btn.is_hover ? @account_button_images_hover[i] : @account_button_images[i]
      end
      @new_user_button.image = @new_user_button.is_hover ? @new_user_button_image_hover : @new_user_button_image

      Sprite.draw(@account_buttons)
      @new_user_button.draw

      if @new_user_button.is_hover || @account_buttons.find {|btn| btn.is_hover }
        Input.set_cursor(IDC_HAND)
      else
        Input.set_cursor(IDC_ARROW)
      end
    end

    def next_scene
      @next_scene || Scene::MainGame.new
    end

    def finish?
      # キーコード定数: https://download.eastback.co.jp/dxruby/api/constant_keycode.html

      if false # @play_button.is_click(M_LBUTTON)
        Input.set_cursor(IDC_ARROW)
        true
      elsif @new_user_button.is_click(M_LBUTTON)
        Input.set_cursor(IDC_ARROW)
        @next_scene = Scene::SelectNew.new
        true
      else
        false
      end
    end
  end
end
