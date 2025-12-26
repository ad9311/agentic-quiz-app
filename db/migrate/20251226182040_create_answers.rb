class CreateAnswers < ActiveRecord::Migration[8.1]
  def change
    create_table(:answers) do |t|
      t.references(:quiz_attempt, null: false, foreign_key: { on_delete: :cascade })
      t.references(:question, null: false, foreign_key: true)
      t.references(:option, null: false, foreign_key: true)
      t.boolean(:correct, null: false, default: false)

      t.timestamps
    end

    add_index(:answers, %i[quiz_attempt_id question_id], unique: true)
  end
end
