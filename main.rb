require_relative 'milight'
require_relative 'rfxcom'
require_relative 'mysensors'
require_relative 'lightwave'
require_relative 'rules'
require_relative 'state'
require_relative 'room'
require_relative 'pinger'
require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

_ = Wildcard.new
rules = Rules.new
state = State.new(rules)
rules.state = state

state[:home] = false

rfxcom = Rfxcom.new(rules)
mysensors = Mysensors.new(rules)
rooms = { :lounge => Room.new({ :floorLamp => Lightwave.new("0xF122AA",1), :wallLights => Milight.new("192.168.1.107",3), :fireLights => Milight.new("192.168.1.107",1), :cabinetLights => Milight.new("192.168.1.107",4), :tableLights => Milight.new("192.168.1.107",2) }), :study => Room.new({:wallLights => Milight.new("192.168.1.130",2), :ceilingLight => Milight.new("192.168.1.130",1), :deskLights => Milight.new("192.168.1.130",3)})}
ping = Pinger.new(rules, { :jonsPhone => "192.168.1.111", :natashasPhone => "192.168.1.132", :loungeTv => "192.168.1.66"})

rules.on [_] do |n|
	puts "fired event: #{n}"
end


rules.on [:mysensors, "22", _, "0"] do |n|

	if(!state[:loungeTv])
		rooms[:lounge][:wallLights].off
        	rooms[:lounge][:fireLights].off
        	rooms[:lounge][:cabinetLights].off
	end
end

rules.on [:mysensors, "22", _, "1"] do |n|
	rooms[:lounge][:wallLights].on
        rooms[:lounge][:fireLights].on
        rooms[:lounge][:cabinetLights].on
end

rules.on [:rfxcom, "0xF2FF87", _, "On"] do |n|
        rooms[:study][:wallLights].on
        rooms[:study][:deskLights].on
end

rules.on [:rfxcom, "0xF2FF87", _, "Off"] do |n|
        rooms[:study][:wallLights].off
	rooms[:study][:deskLights].off
        rooms[:study][:ceilingLight].off
end

rules.on [ :rfxcom, "0xF2FF87", _,"Mood1"] do |n|
	rooms[:study][:deskLights].on
end

rules.on [ :rfxcom, "0xF2FF87", _,"Mood2"] do |n|
	rooms[:study][:wallLights].on
end

rules.on [ :rfxcom, "0xF2FF87", _,"Mood3"] do |n|
	rooms[:study][:ceilingLight].on
end

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
end

rules.on [:rfxcom, "0xF422A3", _, "Off"] do |n|
	rooms[:lounge][:tableLights].off
end

rules.on [:ping] do |n|
	state[n[1]] = n[2]
end


rules.on [:ping, _, true] do |n|
	state[:home] = true;
end

rules.on [:ping, _, false] do |n|
	if(!state[:jonsPhone] && !state[:natashasPhone])
		state[:home] = false;
	end
end

rules.on [:state, :home, true], :given=>[:home, false] do
	puts "now home!"
end

rules.on [:state, :home, false] do
	puts "gone away"
end


scheduler.every '5s' do
	puts "Heartbeat - state is: #{state}"
end


ping.start
scheduler.join
