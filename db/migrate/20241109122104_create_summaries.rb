class CreateSummaries < ActiveRecord::Migration[8.0]
  def change
    create_table :summaries do |t|
      t.string :youtube_id
      t.text :transcript
      t.text :summary

      t.timestamps
    end
  end
end
