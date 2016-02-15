class Api::RacesController < ApplicationController
  before_action :set_race, only: [:update, :destroy]

  def index
    if !request.accept || request.accept == "*/*"
      offset = params[:offset]
      limit = params[:limit]
      render plain: "#{request.env['PATH_INFO']}, offset=[#{offset}], limit=[#{limit}]"
    else
      #real implementation ...
    end
  end

  def show
    if !request.accept || request.accept == "*/*"
      render plain: request.env['PATH_INFO']
    else
      set_race
      render action: :show
    end
  end

  def create
    if !request.accept || request.accept == "*/*"
      render plain: params[:race][:name], status: :ok
    else
      @race = Race.new(race_params)

      if @race.save
        render plain: @race.name, status: :created
      else
        render plain: @race.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    if !request.accept || request.accept == "*/*"
      render plain: request.env['PATH_INFO']
    else
      if @race.update(race_params)
        render json: @race
      else
        render json: @race.errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if !request.accept || request.accept == "*/*"
      render plain: request.env['PATH_INFO']
    else
      @race.destroy
      render :nothing => true, :status => :no_content
    end
  end

  #**************************************#
  # Results
  #**************************************#


  def results

    if !request.accept || request.accept == "*/*"
      render plain: request.env['PATH_INFO']
    else
      @race=Race.find(params[:race_id])
      @entrants = @race.entrants
      fresh_when last_modified: @entrants.max(:updated_at)
    end
  end

  def result
    if !request.accept || request.accept == "*/*"
      render plain: request.env['PATH_INFO']
    else
      @result = Race.find(params[:race_id]).entrants.where(:id=>params[:id]).first
      render partial: 'result', object: @result
    end
  end

  def update_results
    if !request.accept || request.accept == "*/*"
      render plain: request.env['PATH_INFO']
    else
      entrant = Race.find(params[:race_id]).entrants.where(:id=>params[:id]).first

      result=params[:result]
      if result
        if result[:swim]
          entrant.swim=entrant.race.race.swim
          entrant.swim_secs = result[:swim].to_f
        end
        if result[:t1]
          entrant.t1=entrant.race.race.t1
          entrant.t1_secs = result[:t1].to_f
        end
        if result[:bike]
          entrant.bike=entrant.race.race.bike
          entrant.bike_secs = result[:bike].to_f
        end
        if result[:t2]
          entrant.t2=entrant.race.race.t2
          entrant.t2_secs = result[:t2].to_f
        end
        if result[:run]
          entrant.run=entrant.race.race.run
          entrant.run_secs = result[:run].to_f
        end
      end

      if entrant.save
        render nothing: true, status: :ok
      else
        render json: entrant.errors, status: :unprocessable_entity
      end


      # if @race.update(race_params)
      #   render json: @race
      # else
      #   render json: @race.errors, status: :unprocessable_entity
      # end
    end
  end
  private

  def set_race
    @race = Race.find(params[:id])
  end

  def race_params
    params.require(:race).permit(:name, :date)
  end

  rescue_from Mongoid::Errors::DocumentNotFound do |exception|
    @msg = "woops: cannot find race[#{params[:id]}]"

    if !request.accept || request.accept == "*/*"
      render plain: @msg, status: :not_found
    else
      respond_to do |format|
        format.json { render 'error_msg.json', status: :not_found }
        format.xml { render 'error_msg.xml', status: :not_found }
        format.all do
          msg = "woops: we do not support that content-type[#{request.accept}]"
          render plain: msg, status: 415
        end
      end
    end
  end

  rescue_from ActionView::MissingTemplate do |exception|
    msg = "woops: we do not support that content-type[#{request.accept}]"
    render plain: msg, status: 415
  end

end
