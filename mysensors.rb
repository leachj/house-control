require 'simple_ruby_mqtt_client'

class Mysensors
 
  def initialize(rules, aliasMap)
	@rules = rules
	@aliasMap = aliasMap
	
	sc = SimpleMQTTClient.new('192.168.1.70')
	
	sc.subscribe('mysensors-event', lambda do |message|
		nodeId, sensorId, payload = message.split(' ')
          	@rules.process([:mysensors,@aliasMap.fetch(nodeId,nodeId), sensorId, payload])
       end)

  end

end
