class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.string :author
      t.boolean :visibility
      t.string :slug

      t.timestamps
    end
  end
end
