require 'solareventcalculator'

class SunEvents
 
  def initialize(rules, scheduler)
	@rules = rules
	@scheduler = scheduler
	

	@calc = SolarEventCalculator.new(Date.today, BigDecimal.new("52.097994"), BigDecimal.new("1.042622"))

	dateFormat = "%Y%m%d %H:%M"

	sunriseTime = @calc.compute_utc_official_sunrise
	sunsetTime = @calc.compute_utc_official_sunset

	if(sunriseTime > DateTime.now)
	
		scheduler.at sunriseTime.strftime(dateFormat) do
			@rules.process([:sunrise])
		end
	end

	if(sunsetTime > DateTime.now)
		scheduler.at sunsetTime.strftime(dateFormat) do
			@rules.process([:sunset])
		end
	end

	scheduler.cron '5 0 * * *' do
		
		@calc = SolarEventCalculator.new(Date.today, BigDecimal.new("52.097994"), BigDecimal.new("1.042622"))

		scheduler.at @calc.compute_utc_official_sunrise.strftime(dateFormat) do
                	@rules.process([:sunrise])
        	end
        
        	scheduler.at @calc.compute_utc_official_sunset.strftime(dateFormat) do
                	@rules.process([:sunset])
        	end
	end
  end

end
