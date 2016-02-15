class Entrant
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in collection: 'results'

  field :bib, type: Integer
  field :secs, type: Float
  field :o, as: :overall, type: Placing
  field :gender, type: Placing
  field :group, type: Placing

  embeds_many :results, order: [:"event.o".asc], after_add: :update_total, class_name: 'LegResult'
  embeds_one :race, autobuild: true, class_name: 'RaceRef'
  embeds_one :racer, as: :parent, autobuild: true, class_name: 'RacerInfo'

  scope :upcoming, -> { where(:'race.date'.gte => Date.current) }
  scope :past, -> { where(:'race.date'.lt => Date.current) }

  def update_total(result)
    self[:secs] = results.inject(0) { |sum, r| r.secs ? sum + r.secs : sum }
  end

  def the_race
    race.race
  end

  delegate :name, :name=, to: :race, prefix: 'race'
  delegate :date, :date=, to: :race, prefix: 'race'
  delegate :first_name, :first_name=, to: :racer
  delegate :last_name, :last_name=, to: :racer
  delegate :gender, :gender=, to: :racer, prefix: 'racer'
  delegate :birth_year, :birth_year=, to: :racer
  delegate :city, :city=, to: :racer
  delegate :state, :state=, to: :racer

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

  RESULTS = {
    "swim" => SwimResult,
    "t1" => LegResult,
    "bike" => BikeResult,
    "t2" => LegResult,
    "run" => RunResult
  }

  RESULTS.keys.each do |name|
    #create_or_find result
    define_method("#{name}") do
      result=results.select { |result| name==result.event.name if result.event }.first
      if !result
        result=RESULTS["#{name}"].new(:event => {:name => name})
        results << result
      end
      result
    end

    #assign event details to result
    define_method("#{name}=") do |event|
      event=self.send("#{name}").build_event(event.attributes)
    end

    RESULTS["#{name}"].attribute_names.reject { |r| /^_/===r }.each do |prop|

      define_method("#{name}_#{prop}") do
        event=self.send(name).send(prop)
      end
      define_method("#{name}_#{prop}=") do |value|
        event=self.send(name).send("#{prop}=", value)
        update_total nil if /secs/===prop
      end
    end
  end

end
