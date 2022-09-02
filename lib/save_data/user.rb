module SaveData
  class User
    def initialize(name)
      @name = name
      @results = []
    end

    def add_data(score, time: Time.now)
      @results << {
        score: score,
        time: time.strftime("%Y-%m-%d %H:%M:%S")
      }
    end

    def save
      # TODO
      SaveData.save()
    end
  end
end
