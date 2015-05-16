require 'simple_ruby_mqtt_client'

class MultiMilight < Milight

  attr_accessor :state


  def initialize(ip, channel)
	super(ip, channel)
	@state = {:red => false, :green => false}
  end

  def subChannel(subChannel)
	SubMilight.new(subChannel, self)
  end

end

class SubMilight

	def initialize(subChannel, multiMilight)
		@multiMilight = multiMilight
		@subChannel = subChannel
	end

	def on
		@multiMilight.on
		if(@multiMilight.state[other(@subChannel)])
			@multiMilight.colour(:yellow)
		else
			@multiMilight.colour(@subChannel)
		end
		@multiMilight.state[@subChannel] = true;
 	end

  	def off
		if(@multiMilight.state[other(@subChannel)])
			@multiMilight.colour(other(@subChannel))
		else
			@multiMilight.colour(:blue)
			@multiMilight.off
		end
		@multiMilight.state[@subChannel] = false;
  	end

	def other(channel)
		channel == :red ? :green : :red
	end

end
