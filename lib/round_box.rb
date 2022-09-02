class RoundedBox < Image
  def initialize(width, height, color, radius)
    super(width, height, [0, 0, 0, 0])
    r = [radius, width / 2, height / 2,].min
    remain_width =  width - r * 2
    remain_height = height - r * 2

    circle_fill(        r,          r, r, color)
    circle_fill(width - r,          r, r, color)
    circle_fill(        r, height - r, r, color)
    circle_fill(width - r, height - r, r, color)
    if remain_width <= 0 && remain_height <= 0
    elsif remain_width <= 0 # only height
      box_fill(0, r, width, height - r, color)
    elsif remain_height <= 0 # only width
      box_fill(r, 0, width - r, height, color)
    else # all
      box_fill(r, 0, width - r, height, color)
      box_fill(0, r, width, height - r, color)
    end
  end
end
