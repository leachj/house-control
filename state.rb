class State < Hash

	def initialize(rules)
                @rules = rules
        end


	def []=(key, value)
		@rules.process([:state, key, value])
		store(key,value)
  	end

end

