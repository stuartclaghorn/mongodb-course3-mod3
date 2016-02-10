class Address
  attr_accessor :city, :state, :location

  def initialize(city=nil, state=nil, location=nil)
    # Rails.logger.debug { "city=#{city}, state=#{state}, location=#{location}" }
    @city=city 
    @state=state
    @location=location
  end

  # return a database form of the instance
  def mongoize
    {:type=>'Address', :city=>@city, :state=>@state, :loc=>Point.mongoize(@location)}
  end

  # return an instance of the class from the database
  def self.demongoize(params)
    case params
    when Hash then Address.new(params[:city], params[:state], 
                               Point.demongoize(params[:loc]))
    else nil
    end
  end   

  def self.mongoize(object)
    case object
    when Address then object.mongoize
    else object
    end
  end

  def self.evolve(object)
    case object
    when Address then object.mongoize
    else object
    end
  end
end
