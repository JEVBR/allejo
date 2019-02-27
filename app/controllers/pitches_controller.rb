class PitchesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_pitch, only: [:show, :destroy, :edit, :update]

  def index
    @pitches = policy_scope(Pitch).order(created_at: :desc)

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
