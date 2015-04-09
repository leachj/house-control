require 'net/ping'

class Pinger

        def initialize(rules, hosts)
                @pingers = {}
                @rules = rules
		@states = {}
		hosts.each do |key,val|
			@states[key] = false
			@pingers[key] = Net::Ping::ICMP.new(val)
		end
        end

        def start
		Thread.new{
			while true do
				sleep(5)
				@states.each do |key, val|
					newState = @pingers[key].ping
					if(newState!=@states[key])
						@states[key] = newState
						@rules.process([:ping, key, newState])
					end
				end
			end
		}
	end

end

