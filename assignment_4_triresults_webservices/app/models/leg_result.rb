class LegResult
  include Mongoid::Document
  field :secs, type: Float

  embedded_in :entrant
  # embeds_one :event, as: :parent
  embeds_one :event, as: :parent

  validates_presence_of :event

  def calc_ave; end

  after_initialize do |doc|
    calc_ave
  end

  def secs= value
    super
    calc_ave
  end
end
