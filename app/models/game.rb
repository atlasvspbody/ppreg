class Game < ActiveRecord::Base
  belongs_to :player1, class_name:'User'
  belongs_to :player2, class_name:'User'
  validates :player1, presence: true
  validates :player2, presence: true
  validates :player1_score, :numericality => { :less_than_or_equal_to => 21 }, :presence => true
  validates :player2_score, :numericality => { :less_than_or_equal_to => 21 }, :presence => true
  validate :same_players


  after_save :update_scores

  require 'elo'


  def same_players
    if self.player1_id == self.player2_id
    errors.add(:player1, "You cant play with yourself")
    end
  end

  def update_scores
    player1_elo_score = RatedPlayer.new("Player1",self.player1.score)
    player2_elo_score = RatedPlayer.new("Player2",self.player2.score)
    elo_type = 0.5
    if player1_score - 1 > player2_score
      elo_type = 1
    elsif player1_score < player2_score - 1
      elo_type = 0
    end
    Match.new(player1_elo_score,player2_elo_score,elo_type)

    self.player1.update_attribute(:score,player1_elo_score.rating)
    self.player2.update_attribute(:score,player2_elo_score.rating)
  end

  def user_result(user)
    user_score = get_score_user(user)
    opponent_score = get_score_opponent(user)
    result = 'D'
    if user_score - 1 > opponent_score
      result = 'W'
    elsif user_score < opponent_score - 1
      result = 'L'
    end
    result
  end

  def get_score_user(user)
    if player1.id == user.id
      player1_score
    elsif player2.id == user.id
      player2_score
    else
      0
    end
  end

  def get_score_opponent(user)
    if player1.id == user.id
      player2_score
    elsif player2.id == user.id
      player1_score
    else
      0
    end
  end

  def get_opponent(user)
    if player1.id == user.id
      player2
    elsif player2.id == user.id
      player1
    else
      User.new
    end
  end

end
