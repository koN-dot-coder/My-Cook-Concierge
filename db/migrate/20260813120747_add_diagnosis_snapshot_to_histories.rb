class AddDiagnosisSnapshotToHistories < ActiveRecord::Migration[8.0]
  def change
    add_column :histories, :course_label, :string
    add_column :histories, :question_count, :integer
    add_column :histories, :collected_tags, :json, default: []
    add_column :histories, :recommendations, :json, default: {}
  end
end
