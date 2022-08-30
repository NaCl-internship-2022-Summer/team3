module Scene
  class Base
    def initialize
      @count = 0
      @@background = Fixture::Floor.new unless defined? @@background
    end

    def update
      @count += 1
    end

    def next_scene
      raise NotImplementedError
    end

    def finish?
      raise NotImplementedError
    end

    private

    def draw_background
      @@background.draw
    end
  end
end