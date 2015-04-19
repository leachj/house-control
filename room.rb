
class Room < Hash

	def initialize(hash)
		merge!(hash)
	end

	def [](key)
		fetch(key)
	end

	def method_missing(method_sym, *arguments, &block)
		found = false
		each do |n,m|
			if(m.respond_to?(method_sym))
				m.send(method_sym, *arguments)
				found = true
			end
		end

		super unless found
	end

	def respond_to?
		responds=false
		each do |n,m|
			if(m.respond_to?(method_sym))
				responds = true
			end
		end
		responds
	end

end

