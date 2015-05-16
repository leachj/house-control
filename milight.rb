require 'simple_ruby_mqtt_client'

class Milight

  def initialize(ip, channel)
	@ip = ip
	@channel = channel
	@colourMap = {:blue => 3, :yellow => 135, :green => 80, :red => 180 }
	@sc = SimpleMQTTClient.new('192.168.1.70')
  end

  def on
    @sc.publish("milight-control", "#{@ip} #{@channel} on")
  end

  def off
    @sc.publish("milight-control", "#{@ip} #{@channel} off")
  end

  def colour(colour)
    @sc.publish("milight-control", "#{@ip} #{@channel} colour #{@colourMap.fetch(colour, colour)}")
  end
end
