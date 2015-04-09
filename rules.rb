class Wildcard

  def ==(anything)
    true
  end

end

class Rules

        def initialize
                @rules = []
        end

        def on (conditions, &handler)
                @rules << [conditions, handler]
        end

        def process(events)
                @rules.each do |rule|
                        condition = rule[0]
                        code = rule[1]

			minLength = ([condition.length,events.length].min)
			
                        if(condition[0,minLength] == events[0,minLength])

                                code.call events
                        end
                end
        end

end

