require 'simple_ruby_mqtt_client'

class Mysensors
 
  def initialize(rules)
	@rules = rules
	
	sc = SimpleMQTTClient.new('192.168.1.70')
	
	sc.subscribe('mysensors-event', lambda do |message|
          	@rules.process([:mysensors]+message.split(' '))
       end)

  end

end
