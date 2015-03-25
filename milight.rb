require 'simple_ruby_mqtt_client'

class Milight

  def initialize(channel)
	@channel = channel
	@sc = SimpleMQTTClient.new('192.168.1.70')
  end

  def on
    @sc.publish("lights/#{@channel}/power", "on")
  end

  def off
    @sc.publish("lights/#{@channel}/power", "off")
  end

end
