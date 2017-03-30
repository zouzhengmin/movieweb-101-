class CreateMovieusergroups < ActiveRecord::Migration[5.0]
  def change
    create_table :movieusergroups do |t|
      t.integer :movie_id
      t.integer :user_id

      t.timestamps
    end
  end
end
