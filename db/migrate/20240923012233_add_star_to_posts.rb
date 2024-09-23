class AddStarToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :star, :string
  end
end
