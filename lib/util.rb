module Util
  def self.to_radian(degree)
    degree * Math::PI / 180
  end

  def self.to_degree(radian)
    radian * 180 / Math::PI
  end

  def self.symbolize_keys(hash)
    hash.map{|k,v| [k.to_sym, v] }.to_h
  end
end
