class MonthlyPlayersController < ApplicationController
  def index
    @monthly_players = policy_scope(MonthlyPlayer).order(player_name: :desc)
  end
end
