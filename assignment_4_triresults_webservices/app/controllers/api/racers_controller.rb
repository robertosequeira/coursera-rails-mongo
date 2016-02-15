class Api::RacersController < ApplicationController

  def index
    if !request.accept || request.accept == "*/*"
      render plain: request.env['PATH_INFO']
    else
      #real implementation ...
    end
  end

  def show
    if !request.accept || request.accept == "*/*"
      render plain: request.env['PATH_INFO']
    else
    #real implementation ...
    end
  end

  def entries
    if !request.accept || request.accept == "*/*"
      render plain: request.env['PATH_INFO']
    else
      #real implementation ...
    end
  end

  def create
    if !request.accept || request.accept == "*/*"
      render plain: :nothing, status: :ok
    else
      #real implementation ...
    end
  end
end
