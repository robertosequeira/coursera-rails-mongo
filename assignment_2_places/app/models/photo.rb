class Photo
  include ActiveModel::Model

  attr_accessor :id, :location, :contents
  attr_accessor :place

  def initialize(params = nil)
    if params.present?
      @id = params[:_id].to_s || params[:id]
      @location = Point.new(params[:metadata][:location])
      @place = params[:metadata][:place]
    end

    @files = self.class.collection
  end

  def self.mongo_client
    Mongoid::Clients.default
  end

  def self.collection
    mongo_client.database.fs
  end

  def self.all(offset = 0, limit = 0)
    result = collection
      .find
      .skip(offset)
      .limit(limit)

    result.map { |place| Photo.new(place) }
  end

  def self.find(id)
    photo = collection.find(_id: BSON::ObjectId.from_string(id)).first
    photo.nil? ? nil : Photo.new(photo)
  end

  def self.find_photos_for_place(id)
    id = id.is_a?(String) ? BSON::ObjectId.from_string(id) : id
    collection.find({'metadata.place': id})
  end

  def find_nearest_place_id(max_meters)
    place = Place.near(@location, max_meters).limit(1).projection(_id:1).first
    place.nil? ? 0 : place[:_id]
  end

  def persisted?
    @id.present?
  end

  def place
    @place.nil? ? nil : Place.find(@place)
  end

  def place=(place)
    @place = BSON::ObjectId.from_string( place.is_a?(Place) ? place.id : place)
  end

  def save

    if persisted?
      description = {}
      description[:metadata] = {}
      description[:metadata][:location] = @location.to_hash
      description[:metadata][:place] = @place

      @files.find({_id: BSON::ObjectId.from_string(id)}).update_one(:$set => description)

    else
    if @contents
      gps = EXIFR::JPEG.new(@contents).gps
      @location = Point.new(lat: gps.latitude, lng: gps.longitude)

      description = {}
      description[:content_type] = 'image/jpeg'
      description[:metadata] = {}
      description[:metadata][:location] = @location.to_hash
      description[:metadata][:place] = @place

      @contents.rewind
      grid_file = Mongo::Grid::File.new(@contents.read, description)
      @id=@files.insert_one(grid_file)
      end
    end
  end

  def destroy
    @files.find({_id: BSON::ObjectId.from_string(id)}).delete_one
  end

  def contents
    f=@files.find_one({_id: BSON::ObjectId.from_string(@id)})

    if f
      buffer = ""
      f.chunks.reduce([]) do |x, chunk|
        buffer << chunk.data.data
      end
      return buffer
    end
  end
end

