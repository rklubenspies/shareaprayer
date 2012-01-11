require 'rubygems'
require 'mongo_populator'

db = Mongo::Connection.new("localhost", 27017).db("shareaprayer_development")    

collection = db.collection('prayers')
collection.populate(100) do |c|
  c.name              = MongoPopulator.words(1..3).capitalize
  c.request           = MongoPopulator.words(10..30)
  c.ip_address        = "0.0.0.0"
  c.times_prayed_for  = 0
  c.created_at        = (Time.now - 604800)..Time.now
end