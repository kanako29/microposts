class AddAnyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :introduction, :string
    add_column :users, :place, :string
    add_column :users, :homepage, :string
    add_column :users, :birthday, :date
  end
end
