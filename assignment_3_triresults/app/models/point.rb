class Point
  attr_accessor :longitude, :latitude

  def initialize(lng, lat)
    @longitude = lng
    @latitude = lat
  end

  def mongoize
    {:type => 'Point', :coordinates => [@longitude, @latitude]}
  end

  def self.demongoize(object)
    case object
      when Point
        object
      when Hash
        if object[:type]
          Point.new(object[:coordinates][0], object[:coordinates][1])
        else
          Point.new(object[:lng], object[:lat])
        end
      else
        nil
    end
  end

  def self.mongoize(object)
    case object
      when Point
        object.mongoize
      when Hash
        if object[:type]
          Point.new(object[:coordinates][0], object[:coordinates][1]).mongoize
        else
          Point.new(object[:lng], object[:lat]).mongoize
        end
      else
        nil
    end
  end

  def self.evolve(object)
    case object
      when Point
        object.mongoize
      else
        object
    end
  end
end

