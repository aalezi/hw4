class PlacesController < ApplicationController

  def index
    @places = Place.all
  end

  def show
    @place = Place.find_by({ "id" => params["id"] })
    
    if @place
      @entries = Entry.where({ "place_id" => @place["id"], "user_id" => @current_user["id"] })
    else
      flash["notice"] = "Place not found."
      redirect_to "/places"
    end
  end

  def new
    @place = Place.new
  end

  def create
    @place = Place.new
    @place["name"] = params["name"]
    
    if @place.save
      redirect_to "/places"
    else
      flash["notice"] = "Error creating place."
      render "new", status: :unprocessable_entity
    end
  end

end
