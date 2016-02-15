class Placing
  attr_accessor :name, :place

  def initialize(name, place)
    @name = name
    @place = place
  end


  def mongoize
    {name: @name, place: @place}
  end

  def self.demongoize(object)
    case object
      when Placing
        object
      when Hash
        Placing.new(object[:name], object[:place])
      else
        nil
    end
  end

  def self.mongoize(object)
    case object
      when Placing
        object.mongoize
      when Hash
        Placing.new(object[:name], object[:place]).mongoize
      else
        nil
    end
  end

  def self.evolve(object)
    case object
      when Placing
        object.mongoize
      else
        object
    end
  end
end
