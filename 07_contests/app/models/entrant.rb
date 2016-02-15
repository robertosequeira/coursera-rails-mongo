class Entrant
  include Mongoid::Document
  field :_id, type: Integer
  field :name, type: String
  field :group, type: String
  field :secs, type: Float

  belongs_to :racer
  embedded_in :contest

  validates_associated :racer

  before_create do |document|
    racer = document.racer
    document.name = "#{racer.last_name}, #{racer.first_name}" if racer
  end
end
