module Fixture::MainGame
  class Camera
    attr_accessor :fov

    def initialize(player, interiors)
      @player = player
      @fov = 10 # 視野角
      @rays = []
      @rays_color = [100, 255, 255, 255]
      @rays_length = 40
      @window_diagonal = Math.sqrt(Window.width ** 2 + Window.height ** 2)
      @default_image = Image.new(@window_diagonal, 1, @rays_color)
      (- @fov / 2 * @rays_length / 10).upto(@fov * @rays_length / 10) do |i|
        @rays << Sprite.new(@player.cx, @player.cy, @default_image)
        @rays.last.center_x = 0
        @rays.last.angle = Util.to_degree(@player.direction + Util.to_radian(i / (@rays_length / 10).to_f))
      end
      @interiors = interiors
      @interiors_collision_lines = []
      color = [50, 255, 0, 0]
      interiors.each do |interior|
        if interior.collision.nil? || interior.collision.length != 4
          x = interior.x
          y = interior.y
          w = interior.image.width
          h = interior.image.height
        else
          x = interior.x + interior.collision[0]
          y = interior.y + interior.collision[1]
          w = interior.collision[2] - interior.collision[0]
          h = interior.collision[3] - interior.collision[1]
        end
        @interiors_collision_lines << {
          top:    Sprite.new(x,     y,     Image.new(w, 1, [150, 255, 0, 0])),
          bottom: Sprite.new(x,     y + h, Image.new(w, 1, [150, 255, 255, 0])),
          left:   Sprite.new(x,     y,     Image.new(1, h, [150, 0, 255, 0])),
          right:  Sprite.new(x + w, y,     Image.new(1, h, [150, 0, 255, 255]))
        }
      end
    end

    def update(cat)
      lines_w = []
      lines_h = []
      @interiors_collision_lines.each do |lines|
        # choose line
        if (@player.cx - lines[:right].x).abs < (@player.cx - lines[:left].x).abs
          lines_h << lines[:right]
        else
          lines_h << lines[:left]
        end
        if (@player.cy - lines[:top].y).abs < (@player.cy - lines[:bottom].y).abs
          lines_w << lines[:top]
        else
          lines_w << lines[:bottom]
        end
      end
      Sprite.draw(lines_w)
      Sprite.draw(lines_h)

      i = - @fov / 2 * @rays_length / 10
      @rays.each do |ray|
        ray.x = @player.cx
        ray.y = @player.cy
        ray.image = @default_image
        ray.center_x = 0
        ray.angle = Util.to_degree(@player.direction + Util.to_radian(i / (@rays_length / 10).to_f))

        lines_w.length.times do |i|
          flag = false

          if lines_w[i] === ray
            a = lines_w[i].y - @player.cy
            len = (a / Math.cos(Util.to_radian(ray.angle + 90))).abs.floor(2)
            begin
              ray.image = Image.new([1, len].max, 1, @rays_color)
            end
            flag = true
          end
          if lines_h[i] === ray
            a = lines_h[i].x - @player.cx
            len = (a / Math.cos(Util.to_radian(ray.angle))).abs.floor(2)
            ray.image = Image.new([1, len].max, 1, @rays_color)
            flag = true
          end
          next if flag
        end
        i += 1
      end
      # Debugger.puts("hit w: #{hit_count_w}, h: #{hit_count_h}")
    end

    def draw
      # 1. 今のスプライト 〇
      # 2-2. 当たり判定 Sprite#===
      # 3. 当たった時、 camera.ray の座標を、当たったオブジェクトの座標にする
      # 4. ネコに当たったとき、スコア+

      Sprite.draw(@rays)
      # @interiors_collision_lines.each {|lines| Sprite.draw(lines) }
    end
  end
end
