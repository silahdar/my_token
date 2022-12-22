class CreateTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :tokens do |t|
      t.string :secret, limit: 64, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
