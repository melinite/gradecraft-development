class AddKerberosToUsers < ActiveRecord::Migration
  def change
    add_column :users, :kerberos_uid, :string
    add_index :users, :kerberos_uid
  end
end
