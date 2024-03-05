class AddUserIdToArticles < ActiveRecord::Migration[6.1]
  def change
    remove_column :articles, :author
    add_reference :articles, :user, null: false, foreign_key: true
  end
end
