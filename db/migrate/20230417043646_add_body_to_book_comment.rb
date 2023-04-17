class AddBodyToBookComment < ActiveRecord::Migration[6.1]
  def change
    add_column :book_comments, :body, :text
  end
end
