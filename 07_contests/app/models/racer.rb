class Racer
  include Mongoid::Document
  field :first_name, as: :fn,type: String
  field :last_name, as: :ln, type: String
  field :date_of_birth, as: :dob, type: Date

  embeds_one :primary_address, as: :addressable, class_name: 'Address'
  has_one :medical_record, dependent: :destroy

  validates_presence_of :first_name, :last_name

  def races
    # Contest.where('entrants.racer_id' => _id).map{|c|c.entrants}.flatten.select{|e| e.racer_id = id}
    # Contest.where('entrants.racer_id' => _id).map{|c|c.entrants}.flatten
    Contest.where('entrants.racer_id' => id).map{|c|c.entrants.where(racer_id: id).first}
  end
end
