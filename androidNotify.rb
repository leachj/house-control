require 'ruby-notify-my-android'

class AndroidNotify

  def initialize(apiKey)
	@apiKey = apiKey
  end

  def sendNotification(message)
	NMA.notify do |n| 
  		n.apikey = @apiKey
  		n.priority = NMA::Priority::MODERATE
  		n.application = "House-Control"
  		n.event = "Notification"
  		n.description = message
	end
  end

end
