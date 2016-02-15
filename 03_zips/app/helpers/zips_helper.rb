module ZipsHelper
  def toZip(value)
    value.is_a?(Zip) ? value : Zip.new(value)
  end
end
