class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table(:notifications) do |t|
      t.references(:quiz_attempt, null: false, foreign_key: { on_delete: :cascade })
      t.string(:status, null: false)
      t.datetime(:sent_at)
      t.text(:error_message)

      t.timestamps
    end

    add_index(:notifications, :status)
  end
end
