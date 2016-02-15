class Address
  attr_accessor :city, :state, :location

  def initialize(city = nil, state = nil, location = nil)
    @city = city if city
    @state = state if state
    @location = location if location
  end

  def mongoize
    {city: @city, state: @state, loc: @location.mongoize}
  end

  def self.demongoize(object)
    case object
      when Address
        object
      when Hash
        Address.new(object[:city], object[:state], Point.demongoize(object[:loc]))
      else
        nil
    end
  end

  def self.mongoize(object)
    case object
      when Address
        object.mongoize
      when Hash
        Address.new(object[:city], object[:state], Point.demongoize(object[:loc])).mongoize
      else
        nil
    end
  end

  def self.evolve(object)
    case object
      when Address
        object.mongoize
      else
        object
    end
  end
end
