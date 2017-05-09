class HomeController < ApplicationController
  def index
    @notice = params[:notice]
    @users = User.all.forboard
  end

  def history
    @notice = params[:notice]
    @games = current_user.games
  end

  def log
    @game = Game.new
  end

  def log_create
    @game = Game.new(game_params)
    @game.player1 = current_user
    if @game.valid?
      @game.save
      redirect_to history_path notice:'Game saved'
    else
      @notice = @game.errors
      render :log
    end
  end

  def game_params
    params.require(:game).permit(:date_played,:player2_id,:player1_score,:player2_score)
  end

end
