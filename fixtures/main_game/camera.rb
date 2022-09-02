module Fixture::MainGame
  class Camera
    attr_accessor :fov

    def initialize(player, interiors)
      @player = player
      @fov = 10 # 視野角

      # rays
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
        @interiors_collision_lines << collision_lines(interior)
      end
    end

    def update(cat)
      lines_w = []
      lines_h = []
      [
        *@interiors_collision_lines,
        collision_lines(cat)
      ].each do |lines|
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

      ray_count = - @fov / 2 * @rays_length / 10
      @rays.each do |ray|
        ray.x = @player.cx
        ray.y = @player.cy
        ray.image = @default_image
        ray.center_x = 0
        ray.angle = Util.to_degree(@player.direction + Util.to_radian(ray_count / (@rays_length / 10).to_f))

        lines_w.length.times do |i|
          is_hit = false
          is_cat = lines_w.length - 1 == i

          if lines_w[i] === ray # 横の線に当たったら
            a = lines_w[i].y - @player.cy
            len = (a / Math.cos(Util.to_radian(ray.angle + 90))).abs.to_i
            begin # FIXME
              ray.image = Image.new([1, len].max, 1, @rays_color)
            end
            is_hit = true
          end
          if lines_h[i] === ray # 縦の線に当たったら
            a = lines_h[i].x - @player.cx
            len = (a / Math.cos(Util.to_radian(ray.angle))).abs.to_i
            begin
              ray.image = Image.new([1, len].max, 1, @rays_color)
            end
            is_hit = true
          end

          if is_hit && is_cat
            $score += 1
          end

          next if is_hit
        end
        ray_count += 1
      end

      # Debugger.puts("hit w: #{hit_count_w}, h: #{hit_count_h}")
    end

    def draw
      Sprite.draw(@rays)
    end

    private

    def collision_lines(sprite)
      if sprite.collision.nil? || sprite.collision.length != 4
        x = sprite.x
        y = sprite.y
        w = sprite.image.width
        h = sprite.image.height
      else
        x = sprite.x + sprite.collision[0]
        y = sprite.y + sprite.collision[1]
        w = sprite.collision[2] - sprite.collision[0]
        h = sprite.collision[3] - sprite.collision[1]
      end
      {
        top:    Sprite.new(x,     y,     Image.new(w, 1, [150, 255, 0, 0])),
        bottom: Sprite.new(x,     y + h, Image.new(w, 1, [150, 255, 255, 0])),
        left:   Sprite.new(x,     y,     Image.new(1, h, [150, 0, 255, 0])),
        right:  Sprite.new(x + w, y,     Image.new(1, h, [150, 0, 255, 255]))
      }
    end
  end
end
