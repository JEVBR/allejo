class MonthlyPlayersController < ApplicationController
  before_action :set_pitch_params, only: [:new, :create, :edit]
  before_action :set_monthly_player_params, only: [:destroy, :edit, :update]

  def index
    @monthly_players = policy_scope(MonthlyPlayer).joins(:pitch).where(pitches: { user_id: current_user.id })
  end

  def destroy
    @monthly_player.destroy
    redirect_to pitch_monthly_players_path(@monthly_player.pitch)
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
      redirect_to pitch_monthly_players_path(@pitch), notice: 'Mensalista criado com sucesso!'
    else
      render :new
    end
  end

  def edit
    @time_options.each do |option|
      @start_time = option if option[1] == @monthly_player.start_time
      @end_time = option if option[1] == @monthly_player.end_time
    end
  end

  def update
    @pitch = @monthly_player.pitch

    opening_time = (@pitch.opening_time.to_f / 60).ceil
    closing_time = (@pitch.closing_time / 60).floor

    @time_options = []

    (opening_time..closing_time).step(0.5) do |time|
      @time_options << ["#{time.floor}:#{format('%02d', ((time * 60) % 60))}", time * 60]
    end

    if @monthly_player.update(monthly_player_params.merge(pitch_id: @pitch.id))
      redirect_to pitch_monthly_players_path(@pitch.id)
    else
      render :edit
    end
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

  def set_monthly_player_params
    @monthly_player = MonthlyPlayer.find(params[:id])
    authorize @monthly_player
  end
end
