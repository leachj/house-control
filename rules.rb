class Underscore

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

                        if(condition == events)

                                code.call events
                        end
                end
        end

end

