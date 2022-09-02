module SaveData
  class User
    def initialize(name)
      @name = name
      @results = []
    end

    def save(score, time: Time.now)
      @results << {
        score: score,
        time: time.strftime("%Y-%m-%d %H:%M:%S")
      }

      # TODO ファイルに保存する
      # SaveData.save()
    end
  end
end
