class Wildcard

  def ==(anything)
    true
  end

end

class Rules

	attr_writer :state

        def initialize
                @rules = []
        end

        def on (conditions,opts={}, &handler)
                @rules << [conditions, handler, opts]
        end

        def process(events)
                @rules.each do |rule|
                        condition,code,opts = rule

			minLength = ([condition.length,events.length].min)
			
                        if(condition[0,minLength] == events[0,minLength])
				if(opts == {})
                                	code.call events
				else
   					puts "has given condition"
	                             	stateKey,stateVal=opts[:given]
	
					puts "key is #{stateKey} expected value is #{stateVal} actual value is #{@state[stateKey]}"
					if(@state[stateKey]==stateVal)
						puts "given condition matches"
						code.call events
					end
				end
                        end
                end
        end

end

