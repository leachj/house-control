require 'simple_ruby_mqtt_client'

class Rfxcom
 
  def initialize(rules, aliasMap)
	@rules = rules
	@aliasMap = aliasMap
	
	sc = SimpleMQTTClient.new('192.168.1.70')
	
	sc.subscribe('rfxcom-event', lambda do |message|
		code, unit, button = message.split(' ')
          	@rules.process([:rfxcom, @aliasMap.fetch(code,code), unit, button])
       end)

  end

end
