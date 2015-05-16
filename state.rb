class State < Hash

	attr_reader :history

	def initialize(rules)
                @rules = rules
		@history = {}
        end


	def []=(key, value)
		@rules.process([:state, key, value])
		store(key,value)
		data = @history.fetch(key,{})
		data[Time.new]=value
		@history[key]=data
  	end

end

