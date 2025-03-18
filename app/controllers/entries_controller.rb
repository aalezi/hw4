class EntriesController < ApplicationController
  def index
    @entries = Entry.where(user_id: @current_user["id"])  # Only show logged-in user's entries
  end

  def new
    @place = Place.find_by(id: params["place_id"])
    
    if @place.nil?
      flash["notice"] = "Place not found."
      redirect_to "/places"
    else
      @entry = Entry.new
    end
  end

  def create
    if @current_user.nil?
      flash["notice"] = "Login required!"
      redirect_to "/login"
      return
    end

    @entry = Entry.new(entry_params)
    @entry["user_id"] = @current_user["id"]

    if @entry.save
      redirect_to "/places/#{@entry["place_id"]}", notice: "Entry created successfully!"
    else
      flash["notice"] = "Error creating entry."
      render "new", status: :unprocessable_entity
    end
  end

  private

  def entry_params
    params.permit(:title, :description, :occurred_on, :place_id, :uploaded_image)
  end
end
