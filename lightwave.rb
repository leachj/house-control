require 'simple_ruby_mqtt_client'

class Lightwave

  def initialize(code, channel)
	@code = code
	@channel = channel
	@sc = SimpleMQTTClient.new('192.168.1.70')
  end

  def on
    @sc.publish("rfxcom-control", "#{@code} #{@channel} on")
  end

  def off
    @sc.publish("rfxcom-control", "#{@code} #{@channel} off")
  end

end
