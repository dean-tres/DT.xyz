class CreateArticles < ActiveRecord::Migration[6.1]
  def up
    create_table :articles do |t|
      t.string :title, null: false
      t.string :permalink, default: nil
      t.text :content, null: false
      t.boolean :published, default: false
      t.datetime :publish_on, default: nil

      t.timestamps
    end

    add_index :articles, :title, unique: true
  end

  def down
    remove_index :articles, :title, unique: true
    drop_table :articles
  end
end
