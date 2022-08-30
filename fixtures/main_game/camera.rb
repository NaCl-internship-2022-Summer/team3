module Fixture::MainGame
  class Camera
    attr_accessor :fov

    def initialize(player)
      @player = player
      @fov = 10 # 視野角
    end

    def update
    end

    def draw
      len = Math.sqrt(Window.width ** 2 + Window.height ** 2)

      fov_rad = Util.to_radian(@fov)
      (- @fov / 2 * 20).upto(@fov * 20) do |i|
        Window.draw_line(@player.cx, @player.cy,
          @player.cx + len * Math.cos(@player.direction + Util.to_radian(i / 20.0)),
          @player.cy + len * Math.sin(@player.direction + Util.to_radian(i / 20.0)),
          [50, 255, 255, 255])
      end
    end
  end
end
