class RemoveImageIdFromGroup < ActiveRecord::Migration[6.1]
  def change
    remove_column :groups, :image_id, :integer
  end
end
