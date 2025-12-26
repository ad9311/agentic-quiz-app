class CreateQuizzes < ActiveRecord::Migration[8.1]
  def change
    create_table :quizzes do |t|
      t.string :title, null: false
      t.text :description

      t.timestamps
    end

    add_index :quizzes, :title, unique: true
  end
end
