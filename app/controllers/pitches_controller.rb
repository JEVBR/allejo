class PitchesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_pitch, only: [:show, :destroy, :edit, :update]

  def index
    @pitches = policy_scope(Pitch).order(created_at: :desc)

    max_dist = params[:max_dist].to_i
    max_dist = 1_000_000 if max_dist.to_i.zero?
    location = params[:location]

    if location.nil? || location == ""
      lat = request.location.latitude.to_f
      lng = request.location.longitude.to_f
    elsif Geocoder.search(location).first.nil? == false
      lat = Geocoder.search(location).first.boundingbox[0].to_f
      lng = Geocoder.search(location).first.boundingbox[2].to_f
    end

    coordinates_hash = { lng: lng, lat: lat, home: false }
    coordinates_array = [lat, lng]

    # MAP:
    @mark_pitches = Pitch.where.not(latitude: nil, longitude: nil)

    @markers = @mark_pitches.map do |pitch|
      {
        lng: pitch.longitude,
        lat: pitch.latitude,
        infoWindow: pitch.address,
        # pitch_description: pitch.description,
        pitch_title: pitch.title,
        pitch_link: pitch_path(pitch),
        # home_photo: home.photo.url,
        pitch_price: pitch.price,
        home: true
      }
    end
    #End of MAP

    if location.nil? || location == ""
      @markers << { lng: request.location.longitude.to_f, lat: request.location.latitude.to_f, home: false }
    elsif Geocoder.search(location).first.nil? == false
      @markers << coordinates_hash
    end
  end

  def show
    @booking = Booking.new
    authorize @booking
  end

  def destroy
    @pitch.destroy
    redirect_to pitches_path
  end

  def new
    @pitch = Pitch.new
    authorize @pitch

    @categories = policy_scope(Category).order(name: :asc)
  end

  def create
    @pitch = Pitch.new(pitch_params)
    @pitch.user = current_user
    authorize @pitch

    if @pitch.valid?
      @pitch.save
      redirect_to pitch_path(@pitch)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @pitch.update(pitch_params)
    redirect_to pitch_path(@pitch)
  end

  private

  def set_pitch
    @pitch = Pitch.find(params[:id])
    authorize @pitch
  end

  def pitch_params
    params.require(:pitch).permit(:address, :title, :subtitle, :price, :cep, :cnpj, :category_id)
  end
end
