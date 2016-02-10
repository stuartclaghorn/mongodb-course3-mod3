class Entrant
  include Mongoid::Document
	include Mongoid::Timestamps

	store_in collection: "results"

  field :bib, type: Integer
  field :secs, type: Float
  field :o, as: :overall, type: Placing
  field :gender, type: Placing
  field :group, type: Placing

	embeds_many :results, class_name: 'LegResult', order: [:"event.o".asc], after_add: :update_total
  embeds_one :race, class_name: 'RaceRef', autobuild: true
  embeds_one :racer, as: :parent, class_name: 'RacerInfo', autobuild: true
	scope :upcoming, ->{ where(:'race.date'.gte=>Date.today)}
	scope :past, ->{ where(:'race.date'.lt=>Date.today)}

	def update_total(result)
		self.secs=0
		self.results.each do |result|
			if result.secs
				self.secs = self.secs + result.secs
			end
		end
	end

  def the_race
    return self.race.race
  end

  # RacerInfo
  delegate :first_name, :first_name=, to: :racer
  delegate :last_name, :last_name=, to: :racer
  delegate :gender, :gender=, to: :racer, prefix: "racer"
  delegate :birth_year, :birth_year=, to: :racer
  delegate :city, :city=, to: :racer
  delegate :state, :state=, to: :racer
  #RaceRef
  delegate :name, :name=, to: :race, prefix: "race"
  delegate :date, :date=, to: :race, prefix: "race"

  def overall_place 
    overall.place if overall
  end
  def gender_place
    gender.place if gender 
  end
  def group_name 
    group.name if group
  end
  def group_place
    group.place if group 
  end

  #LegResult
  RESULTS = {"swim"=>SwimResult,
             "t1"=>LegResult,
             "bike"=>BikeResult,
             "t2"=>LegResult,
             "run"=>RunResult}

  RESULTS.keys.each do |name|
    # create_or_find result
    define_method("#{name}") do
      result=results.select {|result| name==result.event.name if result.event}.first 
      if !result
        result=RESULTS["#{name}"].new(:event=>{:name=>name})
        results << result
      end
      result
    end

    # assign event details to result
    define_method("#{name}=") do |event|
      event=self.send("#{name}").build_event(event.attributes)
    end

    # expose setter/getter for each property of each result
    RESULTS["#{name}"].attribute_names.reject {|r|/^_/===r}.each do |prop|
      define_method("#{name}_#{prop}") do
        event=self.send(name).send(prop)
      end
      define_method("#{name}_#{prop}=") do |value|
        event=self.send(name).send("#{prop}=",value)
        update_total nil if /secs/===prop
      end
    end
  end
end
