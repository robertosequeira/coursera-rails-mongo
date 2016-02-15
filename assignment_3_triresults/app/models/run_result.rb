class RunResult < LegResult
  field :mmile, as: :minute_mile, type: Float

  def calc_ave
    self[:mmile] = (secs/60)/event.miles if event && secs
  end
end
