class Event
  include Mongoid::Document
  field :o, as: :order, type: Integer
  field :n, as: :name, type: String
  field :d, as: :distance, type: Float
  field :u, as: :units, type: String

	embedded_in :parent, polymorphic: true, touch: true
	validates_presence_of :order, :name

	MILES_PER_METER = 0.000621371
	MILES_PER_KILOMETER = 0.621371
	MILES_PER_YARD = 0.000568182
	METERS_PER_YARD = 0.9144
	METERS_PER_MILE = 1609.34

	def meters
		result=nil
		if units == "meters"
			result=distance
		elsif units == "kilometers"
			result=distance*1000
		elsif units == "miles"
			result=distance*METERS_PER_MILE
		elsif units == "yards"
			result=distance*METERS_PER_YARD
		end
		return result
	end
	
	def miles
		result=nil
		if units == "miles" 
			result=distance
		elsif units == "meters" 
			result=distance*MILES_PER_METER
		elsif units == "kilometers" 
			result=distance*MILES_PER_KILOMETER
		elsif units == "yards" 
			result=distance*MILES_PER_YARD
		end
		return result
	end
end
