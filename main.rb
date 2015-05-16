require_relative 'milight'
require_relative 'multiMilight'
require_relative 'rfxcom'
require_relative 'mysensors'
require_relative 'lightwave'
require_relative 'rules'
require_relative 'state'
require_relative 'room'
require_relative 'pinger'
require_relative 'androidNotify'
require_relative 'sunEvents'
require_relative 'nest'
require_relative 'visualiser'
require 'rufus-scheduler'
require 'sinatra/base'

scheduler = Rufus::Scheduler.new

_ = Wildcard.new
rules = Rules.new
state = State.new(rules)
rules.state = state

state[:home] = false

sunEvents = SunEvents.new(rules, scheduler)
nest = Nest.new(rules, scheduler)
rfxcom = Rfxcom.new(rules, {"0xF2A7FE" => :masterBedroomMoodSwitchR, "0xF2EE67" => :masterBedroomMoodSwitchL, "0xF2FF87"=> :studyMoodSwitch, "0xF40C9E" => :loungeMoodSwitch, "0xF422A3"=> :diningRoomSwitch})
mysensors = Mysensors.new(rules, {"7" => :livingRoomLux, "2" => :doorbell, "22" => :loungeDoor})
androidNotify = AndroidNotify.new("6ee45aa407e99b4ccc678a1a708027d4b58d69c0fcf8d025")

ping = Pinger.new(rules, { 
	:jonsPhone => "192.168.1.111", 
	:natashasPhone => "192.168.1.132",
	:loungeTv => "192.168.1.66"})

masterBedroomMulti = MultiMilight.new("192.168.1.136",1);

rooms = { 
	:lounge => Room.new({ 
		:floorLamp => Lightwave.new("0xF122AA",1), 
		:wallLights => Milight.new("192.168.1.107",3), 
		:fireLights => Milight.new("192.168.1.107",1), 
		:cabinetLights => Milight.new("192.168.1.107",4), 
		:tableLights => Milight.new("192.168.1.107",2) }), 
	:study => Room.new({
		:wallLights => Milight.new("192.168.1.130",2), 
		:ceilingLight => Milight.new("192.168.1.130",1), 
		:deskLights => Milight.new("192.168.1.130",3)}),
	:masterBedroom => Room.new({
		:wardrobeInnerLights => masterBedroomMulti.subChannel(:green),
		:wardrobeOuterLights => masterBedroomMulti.subChannel(:red)
	})
}


rules.on [_] do |n|
	puts "fired event: #{n}"
end

rules.on [:nest] do |n|
	state[:nest]=n[1]
end

rules.on [:mysensors, :livingRoomLux] do |n|
	state[:livingRoomLux] = n[3].to_i
end


rules.on [:mysensors, :doorbell, "1", "0"] do |n|
	androidNotify.sendNotification("Doorbell pressed")
end

rules.on [:mysensors, :loungeDoor, _, "0"] do |n|

	if(!state[:loungeTv])
		rooms[:lounge][:wallLights].off
        	rooms[:lounge][:fireLights].off
        	rooms[:lounge][:cabinetLights].off
	end
end

rules.on [:rfxcom, :masterBedroomMoodSwitchL, _, "On"] do |n|
	rooms[:masterBedroom][:wardrobeOuterLights].on
end

rules.on [:rfxcom, :masterBedroomMoodSwitchL, _, "Mood1"] do |n|
	rooms[:masterBedroom][:wardrobeOuterLights].on
end

rules.on [:rfxcom, :masterBedroomMoodSwitchL, _, "Mood2"] do |n|
	rooms[:masterBedroom][:wardrobeInnerLights].on
end

rules.on [:rfxcom, :masterBedroomMoodSwitchL, _, "Off"] do |n|
	rooms[:masterBedroom][:wardrobeInnerLights].off
	rooms[:masterBedroom][:wardrobeOuterLights].off
end

rules.on [:rfxcom, :masterBedroomMoodSwitchR, _, "On"] do |n|
	rooms[:masterBedroom][:wardrobeOuterLights].on
end

rules.on [:rfxcom, :masterBedroomMoodSwitchR, _, "Mood1"] do |n|
	rooms[:masterBedroom][:wardrobeOuterLights].on
end

rules.on [:rfxcom, :masterBedroomMoodSwitchR, _, "Mood2"] do |n|
	rooms[:masterBedroom][:wardrobeInnerLights].on
end

rules.on [:rfxcom, :masterBedroomMoodSwitchR, _, "Off"] do |n|
	rooms[:masterBedroom][:wardrobeInnerLights].off
	rooms[:masterBedroom][:wardrobeOuterLights].off
end

rules.on [:mysensors, :loungeDoor, _, "1"] do |n|
	rooms[:lounge][:wallLights].on
        rooms[:lounge][:fireLights].on
        rooms[:lounge][:cabinetLights].on
end

rules.on [:rfxcom, :studyMoodSwitch, _, "On"] do |n|
        rooms[:study][:wallLights].on
        rooms[:study][:deskLights].on
end

rules.on [:rfxcom, :studyMoodSwitch, _, "Off"] do |n|
        rooms[:study].off
end

rules.on [ :rfxcom, :studyMoodSwitch, _,"Mood1"] do |n|
	rooms[:study][:deskLights].on
end

rules.on [ :rfxcom, :studyMoodSwitch, _,"Mood2"] do |n|
	rooms[:study][:wallLights].on
end

rules.on [ :rfxcom, :studyMoodSwitch, _,"Mood3"] do |n|
	rooms[:study][:ceilingLight].on
end

rules.on [:rfxcom, :loungeMoodSwitch, _, "On"] do |n|
        rooms[:lounge][:wallLights].on
        rooms[:lounge][:fireLights].on
        rooms[:lounge][:cabinetLights].on
end

rules.on [:rfxcom, :loungeMoodSwitch, _, "Off"] do |n|
        rooms[:lounge].off
end

rules.on [:rfxcom, :loungeMoodSwitch, _, "Mood1"] do |n|
        rooms[:lounge][:tableLights].on
end

rules.on [:rfxcom, :loungeMoodSwitch, _, "Mood2"] do |n|
        rooms[:lounge][:tableLights].off
        rooms[:lounge][:floorLamp].on
end

rules.on [:rfxcom, :loungeMoodSwitch,  _, "Mood3"] do |n|
        rooms[:lounge][:tableLights].off
        rooms[:lounge][:floorLamp].off
end

rules.on [:rfxcom, :diningRoomSwitch, _, "On"] do |n|
	rooms[:lounge][:tableLights].on
end

rules.on [:rfxcom, :diningRoomSwitch, _, "Off"] do |n|
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

scheduler.cron '00 21 * * *' do
	rooms[:masterBedroom][:wardrobeOuterLights].on
end

scheduler.every '5s' do
	puts "#{DateTime.now} Heartbeat - state is: #{state}"
end


ping.start

Visualiser.set :rooms, rooms
Visualiser.set :state, state
Visualiser.run!

#scheduler.join
