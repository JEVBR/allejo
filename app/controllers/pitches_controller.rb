class PitchesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :map]
  before_action :set_pitch, only: [:show, :destroy, :edit, :update]

  def index
    @pitches = policy_scope(Pitch).order(created_at: :desc)
    @categories = policy_scope(Category).order(created_at: :desc)

    max_dist = params[:max_dist].to_i
    max_dist = 1_000_000 if max_dist.to_i.zero?

    params[:date] = Date.today if params[:date].nil?
    params[:category_id] = 2 if params[:category_id].nil?

    # recieve from searchfield in INDEX:
    location = params[:location]

    # keep info (if valid) that the user has written in the searchbox:
    @searchfield = location.nil? || location == '' ? "Procurar endereco" : location

    @distfield = max_dist == 1_000_000 ? "distancia (km)" : max_dist

    # determine default addres if loged in or not
    if user_signed_in?
      user = User.find(current_user.id)
      lat = user.latitude
      lng = user.longitude
    else
      lat = -23.66
      lng = -46.66
    end

    # use the user input from search field
    address = location if Geocoder.search(location).present?

    unless Geocoder.search(address).first.nil?
      lat = Geocoder.search(address).first.latitude.to_f
      lng = Geocoder.search(address).first.longitude.to_f
    end

    # extra bugtrap:
    if lat.nil? || lat.zero? || lng.nil? || lng.zero?
      lng = -46.66
      lat = -23.66
    end

    coordinates_hash = { lng: lng, lat: lat, type: 0 }
    coordinates_array = [lat, lng]

    # MAP:
    @mark_pitches = Pitch.where.not(latitude: nil, longitude: nil).where(category_id: params[:category_id].to_i).near(coordinates_array, max_dist)

    @markers = @mark_pitches.map do |pitch|
      {
        lng: pitch.longitude,
        lat: pitch.latitude,
        infoWindow: pitch.address,
        # pitch_description: pitch.description,
        pitch_company: pitch.company,
        pitch_link: pitch_path(pitch),
        pitch_photo: pitch.photo.url,
        pitch_price: pitch.price,
        type: 1
      }
    end

    if user_signed_in?
      @mark_friends = current_user.friends

      if @mark_friends.present?
        @mark_friends.each do |friend|
          @markers << {
                        lat: friend.latitude,
                        lng: friend.longitude,
                        type: 2
                      }
        end
      end
    end

    #End of MAP

    @markers << coordinates_hash

  end

  def map
    max_dist = params[:max_dist].to_i # Probably break if no good value in field
    authorize Pitch
    lat = params[:lat]
    lng = params[:lng]
    params[:category_id] = 2 if params[:category_id].nil?
    coordinates_hash = { lng: lng.to_f, lat: lat.to_f, type: 0 }
    coordinates_array = [lat, lng]

    # MAP:
    @mark_pitches = Pitch.where.not(latitude: nil, longitude: nil).where(category_id: params[:category_id].to_i).near(coordinates_array, max_dist)

    @markers = @mark_pitches.map do |pitch|
      {
        lng: pitch.longitude,
        lat: pitch.latitude,
        infoWindow: pitch.address,
        # pitch_description: pitch.description,
        pitch_company: pitch.company,
        pitch_link: pitch_path(pitch),
        pitch_photo: pitch.photo.url,
        pitch_price: pitch.price,
        type: 1
      }
    end

    if user_signed_in?
      @mark_friends = current_user.friends

      if @mark_friends.present?
        @mark_friends.each do |friend|
          @markers << {
                        lat: friend.latitude,
                        lng: friend.longitude,
                        type: 2
                      }
        end
      end
    end

    @markers << coordinates_hash

    ActionCable.server.broadcast("ws_#{current_user.id}", "tests")
    ActionCable.server.broadcast("ws_2", "tests_u2")
    ActionCable.server.broadcast("ws_5", "tests_u5")
  end

  def show
    @booking = Booking.new
    authorize @booking

    params[:date] = Date.today.strftime("%F") if params[:date].to_s.empty?
    date = params[:date].to_datetime

    company_pitches = @pitch.user.pitches.where(company: @pitch.company)
    @company_pitches_filtered = company_pitches.where(category: @pitch.category)

    # Uncomment this line for tests
    # @company_pitches_filtered = @pitch.user.pitches

    @pitch_index = @company_pitches_filtered.index(@pitch)
    @next_pitch = @company_pitches_filtered[@pitch_index + 1]
    @last_pitch = @company_pitches_filtered[(@pitch_index - 1).abs]

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
    @categories = policy_scope(Category).order(name: :asc)
  end

  def update
    if @pitch.update(pitch_params)
      redirect_to pitch_path(@pitch)
    else
      redirect_to request.env["HTTP_REFERER"], alert: 'Por favor, verifique os horários de abertura e fechamento'
    end
  end

  private

  def set_pitch
    @pitch = Pitch.find(params[:id])
    authorize @pitch
  end

  def pitch_params
    params.require(:pitch).permit(:address, :company, :title, :price, :cep, :cnpj, :category_id, :photo, :opening_time, :closing_time, :description, :phone)
  end
end
