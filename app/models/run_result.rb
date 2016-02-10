class RunResult < LegResult
  include Mongoid::Document
  field :mmile, as: :minute_mile, type: Float

	def calc_ave
		if event && secs
			miles=event.miles
			self.minute_mile=miles.nil? ? nil : (secs/60)/miles
		end
	end
end
