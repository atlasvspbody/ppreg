class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :trackable, :validatable

  scope :opponents, ->(user) { where('id!=?' ,user.id) }
  scope :forboard, -> { order(score: :desc) }
  def games
    Game.where('player1_id =? OR player2_id =?',self.id,self.id)
  end
end
