require 'simple_ruby_mqtt_client'

class Rfxcom
 
  def initialize(rules)
	@rules = rules
	
	sc = SimpleMQTTClient.new('192.168.1.70')
	
	sc.subscribe('rfxcom-event', lambda do |message|
          	@rules.process([:rfxcom]+message.split(' '))
       end)

  end

end
