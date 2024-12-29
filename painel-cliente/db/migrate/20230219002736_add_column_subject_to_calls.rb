class AddColumnSubjectToCalls < ActiveRecord::Migration[7.0]
  def change
    add_column :calls, :subject, :string
  end
end
