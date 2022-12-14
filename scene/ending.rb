module Scene
  class Ending < Scene::Base
    def initialize(user)
      super()
      @user = user
      @score = $score
      @scores = []
      @user.past_three_data.each do |data|
        @scores << data[:score]
      end
      @font = Font.new(Setting::BEST_SCORE_FONT_SIZE, Setting::FONT_JA)
      @default_font = Font.new(Setting::ENDING_FONT_SIZE, Setting::FONT_JA)
      @sns_font = Font.new(20, Setting::FONT_JA)
      padding = 4
      line_height = 28

      # タイトルに戻る button
      text = "タイトルに戻る"
      w = @default_font.get_width(text) + 10
      @return_title_button_image = Image.new(w, 30).draw_font_ex(padding, padding, text, @default_font, {color: C_BLACK})
      @return_title_button_image_hover = @return_title_button_image.clone.line(padding, line_height, w - padding, line_height, C_BLACK)
      @return_title_button = Button.new(Setting::ENDING_FONT_SIZE, Window.height * 0.85, @return_title_button_image)

      # ゲーム画面に戻る plus_button
      @return_game_image = Image.load("images/button_plus.png")
      @return_game_image_hover = Image.load("images/hover_button_plus.png")
      @return_game_button = Button.new(Window.width * 0.88, Window.height * 0.85, @return_game_image)

      # SNSリザルト画面
      @haikei_image = Image.load("images/haikei_01.png")
      @new_image = Image.load("images/new.png")
      @avatar_image = Image.load("images/avatar.png")
      @heart_image = Image.load("images/heart.png")
      @retweet_image = Image.load("images/retweet.png")
      @comment_image = Image.load("images/comment.png")
      @saisei_image = Image.load("images/button_saisei.png")
      @cat_images = ["images/cat_akubi.png",
                     "images/cat_nobi.png",
                     "images/cat_oikake.png",
                     "images/cat_sleeping.png",
                     "images/cat_kedukuroi.png",
                     "images/cat_hakai.png",
                     "images/cat_manpuku.png",
                     "images/cat_matatabi.png",
                     "images/cat_roubyou.png",
                     "images/cat_ushiro.png"]
      7.times do |n|
        size = @cat_images.size
        @cat_images.delete(@cat_images[rand(size)])
      end
      @preview_cats = []
      @cat_images.each do |cat_image|
        @preview_cats << Image.load(cat_image)
      end

      @next_scene = nil
    end

    def update
      super
      Window.bgcolor = C_WHITE
      # draw_background
      Window.draw_font_ex(Window.width * 0.02, Window.height * 0.1, "ベストスコア", @font, {color: C_BLACK})
      Window.draw_font_ex(Window.width * 0.05, Window.height * 0.2, "#{@user.best_score}", @font, {color: C_BLACK})
      Window.draw_font_ex(Window.width * 0.05, Window.height * 0.3, "いいね！", @font, {color: C_BLACK})
      Window.draw_font_ex(Window.width * 0.80, Window.height * 0.1, "#{@user.name}", @default_font, {color: C_BLACK})
      @return_title_button.image = @return_title_button.is_hover ? @return_title_button_image_hover : @return_title_button_image
      @return_title_button.draw
      if @return_game_button.is_hover
        @return_game_button.image = @return_game_image_hover
        @return_game_button.x = Window.width * 0.87
        @return_game_button.y = Window.height * 0.83
      else
        @return_game_button.image = @return_game_image
        @return_game_button.x = Window.width * 0.88
        @return_game_button.y = Window.height * 0.85
      end
      @return_game_button.draw

      Debugger.print(@user.past_three_data)
      # Debugger.print(@user.best_score)
      # Debugger.print(@scores)


      # リザルト画面
      set_y = [0, Setting::RESULT_VIEW_HEIGHT_FIRST, Setting::RESULT_VIEW_HEIGHT_SECOND, Window.height]
      3.times do |n|
        Window.draw_box_fill(Setting::RESULT_VIEW_WIDTH_START, set_y[n], Setting::RESULT_VIEW_WIDTH_END, set_y[n + 1], C_WHITE)
        Window.draw_box(Setting::RESULT_VIEW_WIDTH_START, set_y[n], Setting::RESULT_VIEW_WIDTH_END, set_y[n + 1], [255, 204, 204, 204])
        Window.draw(Setting::PREVIEW_VIEW_WIDTH_START, set_y[n] + 10, @haikei_image)
        Window.draw_font_ex(Setting::PREVIEW_VIEW_WIDTH_END - 45, set_y[n + 1] - 30, "#{@scores[n]}", @sns_font, {color: C_BLACK})
        Window.draw(Setting::PREVIEW_VIEW_WIDTH_START + 40, set_y[n + 1] - 28, @comment_image)
        Window.draw(Setting::PREVIEW_VIEW_WIDTH_START + 130, set_y[n + 1] - 30, @retweet_image)
        Window.draw(Setting::PREVIEW_VIEW_WIDTH_START + 220, set_y[n + 1] - 30, @heart_image)
        Window.draw(Setting::RESULT_VIEW_WIDTH_START + 15, set_y[n] + 10, @avatar_image)
        Window.draw(Setting::PREVIEW_VIEW_WIDTH_START + (Setting::PREVIEW_VIEW_WIDTH_END - Setting::PREVIEW_VIEW_WIDTH_START)/2 - @preview_cats[n].width/2,
                    set_y[n] + 10,
                    @preview_cats[n])
        Window.draw(Setting::PREVIEW_VIEW_WIDTH_START + (Setting::PREVIEW_VIEW_WIDTH_END - Setting::PREVIEW_VIEW_WIDTH_START)/2 - @saisei_image.width/2,
                    set_y[n + 1] - 40 - Setting::PREVIEW_VIEW_HEIGHT/2 - @saisei_image.height/2,
                    @saisei_image)
      end
      @count = Window.running_time.to_i / 1000
      Window.draw(Setting::RESULT_VIEW_WIDTH_END - @new_image.width, 10, @new_image) if @count.even?

      if @return_game_button.is_click(M_LBUTTON)
        Input.set_cursor(IDC_ARROW)
        @next_scene = Scene::MainGame.new(@user)
      end
    end

    def next_scene
      @next_scene || Scene::Opening.new
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
