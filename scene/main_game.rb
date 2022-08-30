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
      bed_image = Image.load("images/bed_left.png")
      book_shelf_image = Image.load("images/book_shelf.png")
      table_image = Image.load("images/kaku_table.png")
      bed = Interior.new(Window.width - bed_image.width, 0, bed_image)
      book_shelf = Interior.new(0, 0, book_shelf_image)
      kaku_table = Interior.new(250, Window.height/2, table_image)
      @interiors = [bed, book_shelf, kaku_table]
    end

    def update
      super
      draw_background

      @player.update
      @camera.update
      @cat.update
      Interior.update(@interiors)

      @camera.draw
      @player.draw
      @cat.draw
      Interior.draw(@interiors)

      # test 用
      @timer.on if Input.key_push?(K_1)
      @timer.pause if Input.key_push?(K_2)
      @timer.off if Input.key_push?(K_3)
      Window.draw_font(10, 10, "#{@timer.now}", Font.default)
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
