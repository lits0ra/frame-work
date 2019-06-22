require 'active_record'


ActiveRecord::Base.establish_connection(
    adapter: "sqlite3",
    host: "localhost",
    username: "root",
    database: "sample",
    )

class Test < ActiveRecord::Base
end

test = Test.new
test.id = 2
test.name = "bbb"

# DBに保存
test.save

user1 = Test.find_by(id: 2)
puts user1.name
user1.name = "aaa"

# DBに保存
user1.save