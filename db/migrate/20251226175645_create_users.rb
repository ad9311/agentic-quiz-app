class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      email_type = connection.adapter_name.match?(/postg/i) ? :citext : :string
      t.send(email_type, :email, null: false)
      t.string :name, null: false

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
