class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.timestamp :date_played
      t.references :player1, index: true
      t.references :player2, index: true
      t.integer :player1_score
      t.integer :player2_score

      t.timestamps null: false
    end
  end
end
