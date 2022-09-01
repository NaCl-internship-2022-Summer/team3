module Scene
  class MainGame < Scene::Base
    include Fixture::MainGame

    def initialize
      super
      @score = 0
      @count = 0
      @player = Player.new(Window.width/2, Window.height - 50)
      @cat = Cat.new(100, 100, Image.load("images/cat_walking.png"))# 横55 縦56

      @timer = Timer.new
      @bar_length = Setting::PROGRESS_BAR_END - Setting::PROGRESS_BAR_START
      @time_bar_x = @current_len =  Setting::PROGRESS_BAR_START
      @rec_large = Image.new(40, 40).circle_fill(20, 20, 20, [255,192,0,0])
      @rec_midium = Image.new(30, 30).circle_fill(15, 15, 15, C_WHITE)
      @rec_small = Image.new(25, 25).circle_fill(12, 12, 12, [255,192,0,0])

      bed_image = Image.load("images/bed_left.png") # 横300 縦227
      book_shelf_image = Image.load("images/book_shelf.png") # 横192 縦170
      table_image = Image.load("images/kaku_table.png") # 横180 縦145
      bed = Interior.new(Window.width - bed_image.width, 0, bed_image)
      book_shelf = Interior.new(0, 0, book_shelf_image)
      @kaku_table = Interior.new(Window.width/2 - table_image.width, 300, table_image)
      bed.collision = [20, 20, 280, 210]
      book_shelf.collision = [10, 10, 185, 160]
      @kaku_table.collision = [10, 85, 175, 135]
      @interiors = [bed, book_shelf, @kaku_table]

      @camera = Camera.new(@player, @interiors)

      @font = Font.new(Setting::DEFAULT_FONT_SIZE, Setting::FONT_JA)
    end

    def update
      super
      draw_background

      @player.update
      @camera.update(@cat)
      @cat.update
      Interior.update(@interiors)

      @camera.draw
      @cat.draw
      Interior.draw(@interiors)
      @player.draw

      # @interiors.each do |kagu|
      #   Debugger.draw_collision(kagu)
      # end
      # Debugger.draw_collision(@cat)
      # Debugger.draw_msg

      Sprite.check(@player, @interiors)
      Sprite.check(@interiors, @cat)
      Sprite.check(@camera, @cat)

      # test 用
      @timer.on if Input.key_push?(K_1)
      @timer.pause if Input.key_push?(K_2)
      @timer.off if Input.key_push?(K_3)

      percent = [@timer.now / Setting::TIME_LIMIT, 1].min

      Window.draw_box_fill(Setting::PROGRESS_BAR_START, 550, Setting::PROGRESS_BAR_END, 560, C_WHITE)
      Window.draw_box_fill(Setting::PROGRESS_BAR_START, 550, Setting::PROGRESS_BAR_START + percent * @bar_length, 560, [255,192,0,0])
      @count = Window.running_time.to_i / 1000

      @timer.off if percent >= 1
      if 0.8 < percent && percent < 1
        Window.draw_font(Window.width/2 - 5*Setting::DEFAULT_FONT_SIZE,
                         570,
                         "Time: #{@timer.now.round(2)}",
                         @font)
        Window.draw_font(Window.width/2 + 3*Setting::DEFAULT_FONT_SIZE,
                         570,
                         "Score: ？？？",
                         @font)  if @count.even?
      elsif percent < 1
        Window.draw_font(Window.width/2 - 5*Setting::DEFAULT_FONT_SIZE,
                         570,
                         "Time: #{@timer.now.round(2)}",
                         @font)
        Window.draw_font(Window.width/2 + 3*Setting::DEFAULT_FONT_SIZE,
                         570,
                         "Score: #{@score}",
                         @font)
      else
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

      if @timer.status == :on
        Window.draw(48, 532, @rec_large)
        Window.draw(53, 537, @rec_midium)
        Window.draw(56, 540, @rec_small)
      end

      # Window.draw_font(10, 10, Window.real_fps.to_s, Font.default)
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

    def restart?
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
