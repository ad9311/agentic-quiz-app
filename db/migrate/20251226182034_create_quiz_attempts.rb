class CreateQuizAttempts < ActiveRecord::Migration[8.1]
  def change
    create_table(:quiz_attempts) do |t|
      t.references(:user, null: false, foreign_key: true)
      t.references(:quiz, null: false, foreign_key: true)
      t.datetime(:started_at, null: false)
      t.datetime(:completed_at)
      t.integer(:score)
      t.string(:status, null: false)

      t.timestamps
    end

    add_index(:quiz_attempts, %i[user_id created_at])
    add_index(:quiz_attempts, %i[quiz_id created_at])
    add_index(:quiz_attempts, :score)
    add_index(:quiz_attempts, :completed_at, where: "status = 'completed'") if postgresql?
  end

  def postgresql?
    connection.adapter_name.match?(/postg/i)
  end
end
