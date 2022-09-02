module SaveData
  class User
    attr_reader :name, :best_score, :past_three_data

    def initialize(name)
      @name = name
      @results = []
      @latest_data = {}
      @past_three_data = []
      @best_score = 0
    end

    def save(score, time: Time.now)

      @results << {
        score: score,
        time: time.strftime("%Y-%m-%d %H:%M:%S")
      }

      @past_three_data << @results.last
      @past_three_data.values_at(-1, -2, -3)
      # @past_three_data.shift if @past_three_data.size > 4

      if @best_score < score
        @best_score = score
      else
        @best_score
      end

      SaveData.save(
        {
          users: [
            {
              name: @name,
              results: @results
            }
          ]
        }
      )
    end
  end
end
