class Message
  include DataMapper::Resource
  property :id, Serial
  property :sender, String
  property :body, Text
  property :created_at, DateTime
  belongs_to :topic
end
