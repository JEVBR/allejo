class PitchesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_pitch, only: [:show, :destroy, :edit, :update]

  def index
    @pitches = policy_scope(Pitch).order(created_at: :desc)
    @categories = policy_scope(Category).order(created_at: :desc)
    params[:category_id] = 2 if params[:category_id].nil?

    max_dist = params[:max_dist].to_i
    max_dist = 1_000_000 if max_dist.to_i.zero?
    location = params[:location]
    params[:date] = Date.today if params[:date].nil?
    params[:category_id] = 2 if params[:category_id].nil?

    @searchfield = location.nil? || location == '' ? "Procurar endereco" : location
    @distfield = max_dist == 1_000_000 ? "distancia (km)" : max_dist

    # determine default addres if loged in or not
    if user_signed_in?
      user = User.find(current_user.id)
      address = user.address
    else
      address = "Rua Mourato Coelho 1404 Sao Paulo"
    end

    address = location if Geocoder.search(location) != []

    lat = Geocoder.search(address).first.latitude.to_f
    lng = Geocoder.search(address).first.longitude.to_f

    coordinates_hash = { lng: lng, lat: lat, home: false }
    coordinates_array = [lat, lng]

    # MAP:
    @mark_pitches = Pitch.where.not(latitude: nil, longitude: nil).where(category_id: params[:category_id].to_i).near(coordinates_array, max_dist)

    @markers = @mark_pitches.map do |pitch|
      {
        lng: pitch.longitude,
        lat: pitch.latitude,
        infoWindow: pitch.address,
        # pitch_description: pitch.description,
        pitch_title: pitch.title,
        pitch_link: pitch_path(pitch),
        pitch_photo: pitch.photo.url,
        pitch_price: pitch.price,
        home: true
      }
    end
    #End of MAP

    @markers << coordinates_hash

  end

  def show
    @booking = Booking.new
    authorize @booking

    params[:date] = Date.today.strftime("%F") if params[:date].to_s.empty?
    date = params[:date].to_datetime

    @daily_schedule = Booking.pitch_daily_schedule(date, @pitch, 60)
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
    # respond_to do |format|
    #   format.js
    # end

    @pitch = Pitch.new(pitch_params)
    @pitch.user = current_user
    authorize @pitch

   if @pitch.valid?
      @pitch.save
        #respond_to do |format|
        redirect_to pitch_path(@pitch)
        #format.html { redirect_to pitch_path(@pitch) }
        #format.js  # <-- will render `app/views/reviews/create.js.erb`
      #end

    else
        #respond_to do |format|
        render :new
        #format.html { render :new }
        #format.js  # <-- idem
    #end
  end

end

def newlocation
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
    params.require(:pitch).permit(:address, :title, :subtitle, :price, :cep, :cnpj, :category_id, :photo)
  end
end
