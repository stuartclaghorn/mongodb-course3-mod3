class SwimResult < LegResult
  include Mongoid::Document
  field :pace_100, type: Float

	def calc_ave
		if event && secs
			meters=event.meters
			self.pace_100=secs/(meters/100)
		end
	end
end
