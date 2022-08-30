class Timer
  attr_reader :status

  def initialize(start: false)
    @flag = :off
    @passed_time = 0
    start ? on : off
  end

  def now
    return 0 unless @start_time # When not defined

    case @status
    when :on
      Time.now - @start_time + @passed_time
    when :pause, :off
      @passed_time
    end
  end

  def on
    @start_time = Time.now if @status != :on
    @passed_time = 0 if @status == :off # reset
    @status = :on
  end

  def pause
    @passed_time = now
    @status = :pause
  end

  def off
    @passed_time = now if @status == :on
    @status = :off
  end
end
