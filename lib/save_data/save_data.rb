require "json"
require 'fileutils'

module SaveData
  include Crypt

  # json format
  # {
  #   users: [
  #     {
  #       name: String,
  #       results: [
  #         { score: Integer, time: String }, ...
  #       ]
  #     }
  #   ]
  # }

  # return User[]
  def self.load
    begin
      path = File.join($path, Setting::SAVE_FILE_NAME)
      json = open(path) {|file| JSON.load(file) }
      # TODO check format
      json = symbolize_json(json)
    rescue
      return {}
    end
    return json
  end

  def self.save(json)
    file = JSON.pretty_generate(json)
    path = File.join($path, Setting::SAVE_FILE_NAME)
    dir = File.dirname(Setting::SAVE_FILE_NAME)
    FileUtils.mkdir(dir) unless Dir.exists?(dir)
    File.open(path, "w") {|f| f.write(file) }
  end

  private

  def self.symbolize_json(json)
    json = Util.symbolize_keys(json)
    json[:users] = json[:users].map do |user|
      hash = Util.symbolize_keys(user)
      hash[:results] = hash[:results].map {|result| Util.symbolize_keys(result)}
      hash
    end
    json
  end
end
