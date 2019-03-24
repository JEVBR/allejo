class MonthlyPlayersController < ApplicationController
  before_action :set_pitch_params, only: [:new, :create]

  def index
    @monthly_players = policy_scope(MonthlyPlayer).order(player_name: :desc)
  end

  def new
    @monthly_player = MonthlyPlayer.new
    authorize @monthly_player
  end

  def create
    @monthly_player = MonthlyPlayer.new(monthly_player_params)
    @monthly_player.pitch_id = params[:pitch_id]

    authorize @monthly_player

    if @monthly_player.valid?
      @monthly_player.save
      redirect_to request.env["HTTP_REFERER"], notice: 'Mensalista criado com sucesso!'
    else
      render :new
    end
  end

  def destroy

  end

  private

  def monthly_player_params
    params.require(:monthly_player).permit(:player_name, :player_phone, :player_email, :day_of_the_week, :start_time, :end_time, :pitch_id)
  end

  def set_pitch_params
    @pitch = Pitch.find(params[:pitch_id])

    opening_time = (@pitch.opening_time.to_f / 60).ceil
    closing_time = (@pitch.closing_time / 60).floor

    @time_options = []

    (opening_time..closing_time).step(0.5) do |time|
      @time_options << ["#{time.floor}:#{format('%02d', ((time * 60) % 60))}", time * 60]
    end
  end
end
