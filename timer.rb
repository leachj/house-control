class Timer
 
  def initialize(rules)
	@rules = rules
	@timers = {}
  end

  def in(name, seconds, &block)
	time = Time.new
	puts "setting timer"
	@timers[name]=[time+seconds, block]
  end

  def run
	time = Time.new
	sleep (10 - (time.sec % 10))
	while true
		time = Time.new
		@timers.delete_if do |name, timer|
			scheduledTime,block = timer
			if(time > scheduledTime)
				block.call
				true
			end
			false
		end
		@rules.process([:time,time.hour,time.min,time.sec]) 
		sleep 10
	end
  end

end
