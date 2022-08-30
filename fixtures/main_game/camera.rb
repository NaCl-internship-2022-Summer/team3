module Fixture::MainGame
  class Camera
    attr_accessor :fov

    def initialize(player)
      @player = player
      @fov = 10
    end

    def update
    end

    def draw
      len = Math.sqrt(Window.width ** 2 + Window.height ** 2)

      fov_rad = @fov * Math::PI / 180
      (- @fov / 2 * 20).upto(@fov * 20) do |i|
        Window.draw_line(@player.cx, @player.cy,
          @player.cx + len * Math.cos(@player.direction + i / 20.0 * Math::PI / 180),
          @player.cy + len * Math.sin(@player.direction + i / 20.0 * Math::PI / 180),
          C_WHITE)
      end

      Window.draw_font(10, 30, "#{@player.direction}", Font.default)
    end
  end
end
