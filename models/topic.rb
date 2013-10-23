BASE_URI = "topicbot.herokuapp.com"
TOPIC_CHARS = 160

class Topic
  include DataMapper::Resource
  property :id, Serial
  property :topic, Text
  property :creator, String
  property :created_at, DateTime

  has n, :messages

  def url
    return "#{BASE_URI}/topic/#{self[:id]}"
  end

  def shortened_topic
    self[:topic].length < TOPIC_CHARS ? self[:topic] : self[:topic].slice(0, TOPIC_CHARS).concat('...')
  end
end
