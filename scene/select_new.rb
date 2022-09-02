module Scene
  class SelectNew < Scene::Base
    def initialize
      super

      @title_font = Font.new(Setting::TITLE_FONT_SIZE, Setting::FONT_JA)
      @background = Image.new(Window.width, Window.height, C_WHITE)

      # describe
      @describe_oy = 180
      @describe_font = Font.new(Setting::DESCRIBE_FONT_SIZE, Setting::FONT_JA)

      # user name text box
      w = 300
      h = 40
      @text_box = TextBox.new(
        (Window.width - w) / 2, Window.height * 0.6, w, h, "",
        font_name: Setting::FONT_JA,
        font_color: Setting::FONT_COLOR_BLACK,
        frame_color: Setting::FONT_COLOR_BLACK
      )

       # account name title
       text = "アカウント名"
       font = Font.new(16, Setting::FONT_JA)
       padding = 4
       w = font.get_width(text) + 10
       @account_name_title = Sprite.new(
         @text_box.x, Window.height * 0.55,
         Image.new(w, 40).draw_font_ex(padding, padding, text, font, { color: Setting::FONT_COLOR_BLACK })
       )

      # new save data
      text = "ゲームスタート"
      font = Font.new(32, Setting::FONT_JA)
      padding = 4
      w = font.get_width(text) + 10
      @new_user_button_image = Image.new(w, 40).draw_font_ex(padding, padding, text, font, { color: Setting::FONT_COLOR_BLACK })
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

      @account_name_title.draw

      @text_box.update
      @text_box.draw

      @new_user_button.image = @new_user_button.is_hover ? @new_user_button_image_hover : @new_user_button_image

      Sprite.draw(@account_buttons)
      @new_user_button.draw

      if @new_user_button.is_hover # @play_button.is_hover
        Input.set_cursor(IDC_HAND)
      else
        Input.set_cursor(IDC_ARROW)
      end
    end

    def next_scene
      Scene::MainGame.new()
      # Scene::MainGameStart.new
    end

    def finish?
      # キーコード定数: https://download.eastback.co.jp/dxruby/api/constant_keycode.html

      if false # @play_button.is_click(M_LBUTTON)
        Input.set_cursor(IDC_ARROW)
        true
      elsif @new_user_button.is_click(M_LBUTTON)
        Input.set_cursor(IDC_ARROW)

        # TODO
        # @user = User.new()
        true
      else
        false
      end
    end
  end
end
