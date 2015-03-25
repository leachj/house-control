class Timer
 
  def initialize(rules)
	@rules = rules
  end

  def run
	time = Time.new
	sleep (10 - (time.sec % 10))
	while true
		time = Time.new
		@rules.process([:time,time.hour,time.min,time.sec]) 
		sleep 10
	end
  end

end
