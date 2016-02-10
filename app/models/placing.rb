class Placing
  attr_accessor :name, :place

  def initialize(name, place)
    @name=name
    @place=place
  end

  # return a database form of the instance
  def mongoize
    {:name=>@name, :place=>@place}
  end

  # return an instance of the class from the database
  def self.demongoize(params)
    case params
    when Hash then Placing.new(params[:name], params[:place])
    else nil
    end
  end   

  def self.mongoize(object)
    case object
    when Placing then object.mongoize
    else object
    end
  end

  def self.evolve(object)
    case object
    when Placing then object.mongoize
    else object
    end
  end
end
