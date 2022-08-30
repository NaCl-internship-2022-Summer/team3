class TextBox
  attr_accessor :x, :y, :width, :height, :font_name, :font_size, :text, :frame_color, :font_color, :focused

  def initialize(
                 x,
                 y,
                 width,
                 height,
                 text,
                 font_name: '',
                 font_size: height * 0.8,
                 font_color: C_WHITE,
                 font_ox: 0,
                 font_oy: 0,
                 frame_color: C_WHITE,
                 cursor_scale: 1
                )
    @x = x
    @y = y
    @width = width
    @height = height
    @text = text
    @font_size = font_size
    @frame_color = frame_color
    @font_color = font_color
    @font = Font.new(@font_size, font_name)
    @frame = Sprite.new(@x, @y, Image.new(@width, @height).box(0, 0, @width, @height, @frame_color))
    @text_sprite = Sprite.new(
      @x + @width * 0.03 + font_ox,
      @y + @height * 0.1 + font_oy,
      Image.new(@width * 0.94, @height * 0.8).draw_font(0, 0, @text, @font, @font_color)
    )
    @cursor = Sprite.new(
      @x + @width * 0.03,
      @y + @height * 0.1,
      Image.new(1, @font_size * cursor_scale, @frame_color)
    )
    @focused = true
    @tick = 0
    @alphabet = ('a'..'z').to_a
    @cursor_rate = 60
  end

  def update
    return nil unless @focused

    @tick += 1
    typing_keyboard
    w = @font.get_width(@text)
    if w > @text_sprite.image.width
      @cursor.x = @text_sprite.x + @text_sprite.image.width + 1
      diff = w - @text_sprite.image.width
      @text_sprite.image =  Image.new(@width * 0.94, @height * 0.8).draw_font(-diff, 0, @text, @font, @font_color)
    else
      @cursor.x = @frame.x + @width * 0.03 + w
      @text_sprite.image = Image.new(@width * 0.94, @height * 0.8).draw_font(0, 0, @text, @font, @font_color)
    end
  end

  def draw
    @frame.draw
    @text_sprite.draw
    if @focused && (@tick % @cursor_rate * 2 < @cursor_rate)
      @cursor.draw
    end
  end

  private

  def typing_keyboard
    26.times do |i|
      next unless Input.key_push?(eval("K_#{@alphabet[i].upcase}"))

      if Input.key_down?(K_LSHIFT) || Input.key_down?(K_RSHIFT)
        @text += @alphabet[i].upcase
      else
        @text += @alphabet[i]
      end
    end
    if Input.key_push?(K_SPACE) || Input.key_down?(K_SPACE) && @tick % 6 == 0
      @text << ' '
    end
    if @text.length > 0 && (Input.key_push?(K_BACK) || Input.key_down?(K_BACK) && @tick % 6 == 0)
      @text.chop!
    end
  end
end
