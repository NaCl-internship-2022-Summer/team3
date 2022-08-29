module Scene
  class MainGame < Scene::Base
    include Fixture::MainGame

    def initialize
      super
      @score = 0
      @player = Player.new(Window.width/2, Window.height - 50)

      @cat = Cat.new(100, 100, Image.load("images/cat_walking.png"))
    end

    def update
      super
      move_background_down_and_draw

      @player.update
      @player.draw

      @cat.update
      @cat.draw
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