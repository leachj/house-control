require 'net/ping'

class Pinger

        def initialize(rules, host)
                @pinger = Net::Ping::ICMP.new(host)
                @rules = rules
		@state = false
		@host = host
        end

        def start
		Thread.new{
			while true do
				sleep(5)
				newState = ping()
				if(newState!=@state)
					@state = newState
					@rules.process([:ping, @host, @state])
				end
			end
		}
	end

	def ping
		@pinger.ping 
	end

end

