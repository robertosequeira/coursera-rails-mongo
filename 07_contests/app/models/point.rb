class Point
  include Mongoid::Document

  attr_accessor :longitude, :latitude

  def initialize(lng, lat)
    @latitude = lat
    @longitude = lng
  end

  def mongoize
    {type: 'Point', coordinates: [@longitude, @latitude]}
  end

  def self.demongoize(object)
    case object
      when Hash
        Point.new(object[:coordinates][0], object[:coordinates][1])
      else
        nil
    end
  end

  def self.mongoize(object)
    case object
      when Point
        object.mongoize
      else
        object
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

