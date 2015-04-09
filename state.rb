class State < Hash

	def initialize(rules)
                @rules = rules
        end


	def []=(key, value)
		store(key,value)
		@rules.process([:state, key, value])
  	end

end

