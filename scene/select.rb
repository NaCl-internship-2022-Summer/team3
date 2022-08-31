module Scene
  class Select < Scene::Base
    def initialize
      super

      @title_font = Font.new(Setting::TITLE_FONT_SIZE)
      @background = Image.new(Window.width, Window.height, C_WHITE)

      # describe
      @describe_oy = 200
      @describe_font = Font.new(Setting::DESCRIBE_FONT_SIZE)

      font = Font.new(32)
      padding = 4
      line_height = 38


      json = SaveData.load
      @users = json[:users]
      @account_button_images = []
      @account_button_images_hover = []
      @account_buttons = []

      @users.each_with_index do |user, i|
        text = user[:name]
        w = font.get_width(text) + 10
        @account_button_images << Image.new(w, 40).draw_font(padding, padding, text, font, [40, 40, 40])
        @account_button_images_hover << @account_button_images.last.clone.line(padding, line_height, w - padding, line_height, [40, 40, 40])
        @account_buttons << Button.new(
          (Window.width - @account_button_images.last.width) / 2,
          Window.height * 0.6, @account_button_images.last
        )
      end

      # use save data

      # new save data
      text = "Create new account"
      w = font.get_width(text) + 10
      @new_user_button_image = Image.load("images/create_new_account.png")
      @new_user_button_image.set_color_key(C_BLACK)
      @new_user_button_image_hover = @new_user_button_image.clone
      @new_user_button = Button.new((Window.width - @new_user_button_image.width) / 2, Window.height * 0.8, @new_user_button_image)
    end

    def update
      super
      Window.draw(0, 0, @background)
      Window.draw_font(40, 50, "ネコったー", @title_font, {color: [40, 40, 40]})

      Setting::DESCRIBE_TEXTS.each_with_index do |text, i|
        Window.draw_font(
          (Window.width - @describe_font.get_width(text)) / 2,
          @describe_oy + @describe_font.size * i,
          text,
          @describe_font,
          {color: [40, 40, 40]}
        )
      end

      @account_buttons.each_with_index do |btn, i|
        btn.image = btn.is_hover ? @account_button_images_hover[i] : @account_button_images[i]
      end
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
      Scene::MainGame.new
    end

    def finish?
      # キーコード定数: https://download.eastback.co.jp/dxruby/api/constant_keycode.html

      if false # @play_button.is_click(M_LBUTTON)
        Input.set_cursor(IDC_ARROW)
        true
      elsif @new_user_button.is_click(M_LBUTTON) || Input.key_push?(K_ESCAPE)
        Input.set_cursor(IDC_ARROW)
        true
      else
        false
      end
    end
  end
end