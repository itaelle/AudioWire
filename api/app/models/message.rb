class Message < ActiveRecord::Base

  establish_connection :openfiredb
  @abstract_class = true
  # set_table_name ofUser
  # set_primary_key username
  # set_inheritance_column :ruby_type
end