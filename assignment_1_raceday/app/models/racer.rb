class Racer
  include ActiveModel::Model

  attr_accessor :id, :number, :first_name, :last_name, :gender, :group, :secs

  # initialize from both a Mongo and Web hash
  def initialize(params={})
    @id = params[:_id].nil? ? params[:id] : params[:_id].to_s
    @number = params[:number]
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @gender = params[:gender]
    @group = params[:group]
    @secs = params[:secs].to_i
  end

  def self.mongo_client
    Mongoid::Clients.default
  end

  def self.collection
    self.mongo_client['racers']
  end

  def self.all(prototype = {}, sort = {number: 1}, offset=0, limit=nil)
    result =
      collection
        .find(prototype)
        .sort(sort)
        .skip(offset)
    result = result.limit(limit) if limit.present?

    result
  end

  def self.find(id)
    racer = collection.find(:_id => BSON::ObjectId.from_string(id)).first
    racer.nil? ? nil : Racer.new(racer)
  end

  def self.paginate(params)
    page=(params[:page] ||= 1).to_i
    limit=(params[:per_page] ||= 30).to_i
    offset=(page-1)*limit
    sort=params[:sort] ||= {number: 1}


    racers=[]
    all({}, {}, offset, limit).each do |doc|
      racers << Racer.new(doc)
    end

    #get a count of all documents in the collection
    total=all.count

    WillPaginate::Collection.create(page, limit, total) do |pager|
      pager.replace(racers)
    end
  end

  def persisted?
    @id.present?
  end

  def created_at
    nil
  end

  def updated_at
    nil
  end

  def save
    @id = self.class.collection
      .insert_one(number: @number, first_name: @first_name, last_name: @last_name,
                  gender: @gender, group: @group, secs: @secs)
      .inserted_id
  end

  def update(params)
    @number = params[:number].to_i
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @gender = params[:gender]
    @group = params[:group]
    @secs = params[:secs].to_i

    params.slice!(:number, :first_name, :last_name, :gender, :group, :secs) if params.present?

    self.class.collection
      .find(_id: BSON::ObjectId.from_string(@id))
      .update_one(:$set => {
        number: @number, first_name: @first_name, last_name: @last_name,
        gender: @gender, group: @group, secs: @secs})
  end

  def destroy
    self.class.collection
      .find(_id: BSON::ObjectId.from_string(@id))
      .delete_one
  end


end
