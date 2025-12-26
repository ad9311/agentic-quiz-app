class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions do |t|
      t.references :quiz, null: false, foreign_key: { on_delete: :cascade }
      t.text :body, null: false
      t.text :explanation

      t.timestamps
    end
  end
end
