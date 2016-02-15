class Racer
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in collection: 'racer1'

  field :first_name, as: :fn,type: String
  field :last_name, as: :ln, type: String
  field :date_of_birth, as: :dob, type: Date
  field :gender, type: String

  before_upsert do |doc|
    doc.set_updated_at
  end
end
