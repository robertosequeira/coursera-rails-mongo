class Event
  include Mongoid::Document
  field :o, as: :order, type: Integer
  field :n, as: :name, type: String
  field :d, as: :distance, type: Float
  field :u, as: :units, type: String

  embedded_in :parent, polymorphic: true, touch:true

  validates_presence_of :order, :name

  def meters
    if distance && units
      case units
        when 'miles'
          distance * 1609.34
        when 'kilometers'
          distance * 1000
        when 'meters'
          distance
        when 'yards'
          distance * 0.9144
        else
          nil
      end
    else
      nil
    end
  end

  def miles
    if distance && units
      case units
        when 'miles'
          distance
        when 'kilometers'
          distance * 0.621371
        when 'meters'
          distance * 0.000621371
        when 'yards'
          distance * 0.9144 * 0.000621371
        else
          nil
      end
    else
      nil
    end
  end
end
