require "json"

module SaveData
  include Crypt

  # json format
  # {
  #   users: [
  #     {
  #       name: String,
  #       results: [
  #         score: Integer,
  #         time: String
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
