module Scene
  class MainGame < Scene::Base
    include Fixture::MainGame

    def initialize
      super
      @score = 0
      @player = Player.new(Window.width/2, Window.height - 50)
      @camera = Camera.new(@player)
      @cat = Cat.new(100, 100, Image.load("images/cat_walking.png"))

      @timer = Timer.new
      @bar_length = Setting::PROGRESS_BAR_END - Setting::PROGRESS_BAR_START
      @time_bar_x = @current_bar_x = @current_len =  Setting::PROGRESS_BAR_START2

      bed_image = Image.load("images/bed_left.png") # 横300 縦227
      book_shelf_image = Image.load("images/book_shelf.png") # 横192 縦170
      table_image = Image.load("images/kaku_table.png") # 横180 縦145
      bed = Interior.new(Window.width - bed_image.width, 0, bed_image)
      book_shelf = Interior.new(0, 0, book_shelf_image)
      @kaku_table = Interior.new(Window.width/2 - table_image.width, 300, table_image)

      bed.collision = [280, 10, 20, 210, 230, 210]
      book_shelf.collision = [10, 10, 185, 160]
      @kaku_table.collision = [10, 85, 175, 135]
      @interiors = [bed, book_shelf, @kaku_table]

      @font = Font.new(Setting::DEFAULT_FONT_SIZE, Setting::FONT_JA)
    end

    def update
      super
      draw_background

      @player.update
      @camera.update
      @cat.update
      Interior.update(@interiors)

      @camera.draw
      @cat.draw
      Interior.draw(@interiors)
      @player.draw
      @kaku_table.draw

      Sprite.check(@player, @interiors)

      # test 用
      @timer.on if Input.key_push?(K_1)
      @timer.pause if Input.key_push?(K_2)
      @timer.off if Input.key_push?(K_3)
      Window.draw_box_fill(Setting::PROGRESS_BAR_START, 550, Setting::PROGRESS_BAR_END, 560, C_WHITE)

      @current_len = Setting::PROGRESS_BAR_START + (@bar_length / Setting::TIME_LIMIT) * @timer.now
      @current_len = Setting::PROGRESS_BAR_END if @current_len > Setting::PROGRESS_BAR_END

      case @timer.status
      when :on
        Window.draw_box_fill(100, 550, @time_bar_x, 560, C_RED)
        @time_bar_x = @current_len
        @current_bar_x = @time_bar_x
        @timer.off if @time_bar_x == Setting::PROGRESS_BAR_END
       if @time_bar_x < Setting::PROGRESS_BAR_END
        Window.draw_font(Window.width/2 - 8*Setting::DEFAULT_FONT_SIZE/2,
                           570,
                           "Time: #{@timer.now}",
                           @font)
       end
      when :pause, :off
        Window.draw_box_fill(Setting::PROGRESS_BAR_START, 550, @current_bar_x, 560, C_RED)
        if @current_bar_x == 100
          Window.draw_font(Window.width/2 - 8*Setting::DEFAULT_FONT_SIZE/2,
                           570,
                           "Time Limit: 1:00",
                           @font)
        elsif @current_bar_x < Setting::PROGRESS_BAR_END
          Window.draw_font(Window.width/2 - 8*Setting::DEFAULT_FONT_SIZE/2,
                           570,
                           "Time: #{@timer.now}",
                           @font)
        elsif @current_bar_x == Setting::PROGRESS_BAR_END
          Window.draw_font(Window.width/2 - 6*Setting::DEFAULT_FONT_SIZE/2,
                           570,
                           "Finish: 1:00",
                           @font)
          Window.draw_font(Window.width/2 - 5*Setting::DEFAULT_FONT_SIZE/2,
                           Window.height/2 - Setting::DEFAULT_FONT_SIZE/2,
                           "Time Over",
                           @font,
                           {color: C_RED})
        end
      end
    end

    def next_scene
      Scene::Ending.new(@score)
    end

    def finish?
      # キーコード定数: https://download.eastback.co.jp/dxruby/api/constant_keycode.html
      quit_key = [K_ESCAPE]
      quit_key.each do |key|
        return true if Input.key_push?(key)
      end
      false
    end

    private

    def management_enemy
      # 敵が10体未満なら、10体追加
      if Enemy.collection.length < 10
        enemy_img = Image.new(64, 64, C_RED)
        10.times do |i|
          Enemy.add(rand(150) + 150, rand(150) + 150, enemy_img)
        end
      end

      Enemy.collection.each do |enemy|
        enemy.update
        enemy.draw
      end
    end
  end
end
