class PitchesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @pitches = policy_scope(Pitch).order(created_at: :desc)
  end
end
