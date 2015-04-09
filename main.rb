require_relative 'milight'
require_relative 'rfxcom'
require_relative 'lightwave'
require_relative 'timer'
require_relative 'rules'
require_relative 'room'
require_relative 'pinger'

_ = Wildcard.new
rules = Rules.new
state = {}

def given(foo, &bar)
	[]
end

rfxcom = Rfxcom.new(rules)
timer = Timer.new(rules)
rooms = { :lounge => Room.new({ :floorLamp => Lightwave.new("0xF122AA",1), :wallLights => Milight.new(3), :fireLights => Milight.new(1), :cabinetLights => Milight.new(4), :tableLights => Milight.new(2) })}

ping = Pinger.new(rules, "192.168.1.111")

rules.on [:rfxcom, "0xF40C9E", _, "On"] do |n|
        rooms[:lounge][:wallLights].on
        rooms[:lounge][:fireLights].on
        rooms[:lounge][:cabinetLights].on
end

rules.on [:rfxcom, "0xF40C9E", _, "Off"] do |n|
        rooms[:lounge].off
end

rules.on [:rfxcom, "0xF40C9E", _, "Mood1"] do |n|
        rooms[:lounge][:tableLights].on
end

rules.on [:rfxcom, "0xF40C9E", _, "Mood2"] do |n|
        rooms[:lounge][:tableLights].off
        rooms[:lounge][:floorLamp].on
end

rules.on [:rfxcom, "0xF40C9E", _, "Mood3"] do |n|
        rooms[:lounge][:tableLights].off
        rooms[:lounge][:floorLamp].off
end

rules.on [:rfxcom, "0xF422A3", _, "On"] do |n|
	rooms[:lounge][:tableLights].on
#	timer.in(:test,5) do 
#		rooms[:lounge][:tableLights].off
#	end
end

#rules.on [:time, 21, 38, _] do |n|
#	rooms[:lounge][:tableLights].on
#end

rules.on [:rfxcom, "0xF422A3", _, "Off"] do |n|
	rooms[:lounge][:tableLights].off
end

rules.on [_, _, _, _] do |n|
	puts "fired event: #{n}"
end

rules.on [_, _, _, _] do |n|
	if(state[:test]) then puts "test state true" end
end


ping.start
timer.run
