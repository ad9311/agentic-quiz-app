class CreateOptions < ActiveRecord::Migration[8.1]
  def change
    create_table(:options) do |t|
      t.references(:question, null: false, foreign_key: { on_delete: :cascade })
      t.text(:text, null: false)
      t.boolean(:correct, null: false, default: false)

      t.timestamps
    end

    add_index(:options, %i[question_id correct])
  end
end
