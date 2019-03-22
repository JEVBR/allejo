class MonthlyPlayersController < ApplicationController
  def index
    @monthly_players = policy_scope(MonthlyPlayer).order(player_name: :desc)
  end

  def new
    @monthly_player = MonthlyPlayer.new
    @pitch = Pitch.find(params[:pitch_id])
    authorize @monthly_player

    opening_time = @pitch.opening_time / 60
    closing_time = @pitch.closing_time / 60

    @time_options = []

    (opening_time..closing_time).step(0.5) do |time|
      @time_options << ["#{time.ceil}:#{format('%02d', ((time % 1) * 60))}", time * 60]
    end
  end
end
