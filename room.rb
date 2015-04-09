
class Room

        def initialize(contents)
                @contents = contents
        end

	def [](key)
		@contents[key]
	end

	def method_missing(method_sym, *arguments, &block)
		found = false
		@contents.each do |n,m|
			if(m.respond_to?(method_sym))
				m.send(method_sym, *arguments)
				found = true
			end
		end

		super unless found
	end

	def respond_to?
		responds=false
		@contents.each do |n,m|
			if(m.respond_to?(method_sym))
				responds = true
			end
		end
		responds
	end

end

