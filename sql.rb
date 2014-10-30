require 'sqlite3'
require 'active_record'
require "./conf.rb"

ID = InitData.new()    
data = ID.getInitData()

ActiveRecord::Base.establish_connection(
    adapter:  data['sql']['adapter'],
    host:     data['sql']['host'],
    database: data['sql']['database']
    )

class Company < ActiveRecord::Base
end




