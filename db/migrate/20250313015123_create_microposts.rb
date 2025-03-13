class CreateMicroposts < ActiveRecord::Migration[7.0]
  INDEX = %i(user_id created_at)
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :microposts, INDEX
  end
end
