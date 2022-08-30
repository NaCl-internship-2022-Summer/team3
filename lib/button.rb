class Button < Sprite
  def initialize(x, y, image)
    super(x, y, image)
  end

  def is_hover
    mx = Input.mouse_x
    my = Input.mouse_y
    (self.x <= mx && mx <= self.x + self.image.width &&
     self.y <= my && my <= self.y + self.image.height)
  end

  # mouse_button: M_LBUTTON | M_MBUTTON | M_RBUTTON
  def is_click(mouse_button)
    is_hover && Input.mouse_push?(mouse_button)
  end

  def on_hover
    yield if is_hover
  end

  # mouse_button: M_LBUTTON | M_MBUTTON | M_RBUTTON
  def on_click(mouse_button)
    yield if is_click(mouse_button)
  end
end
