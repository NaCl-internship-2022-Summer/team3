module Util
  def self.to_radian(degree)
    degree * Math::PI / 180
  end

  def self.to_degree(radian)
    radian * 180 / Math::PI
  end
end
