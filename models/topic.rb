BASE_URI = "topicbot.herokuapp.com"

class Topic
  include DataMapper::Resource
  property :id, Serial
  property :topic, String, :length => 160
  property :creator, String
  property :created_at, DateTime

  has n, :messages

  def url
    return "#{BASE_URI}/topic/#{self[:id]}"
  end
end
