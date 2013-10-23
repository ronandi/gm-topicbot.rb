require 'chatbot'
require 'sinatra'
require 'data_mapper'
require './models/topic'
require './models/message'
require 'tzinfo'
require 'logger'

logger = Logger.new(STDOUT)

use Rack::Auth::Basic, "Not Found" do |username, password|
  username == ENV['TOPICBOT_USER'] and password == ENV['TOPICBOT_PASSWORD']
end

before do
    logger.level = Logger::DEBUG
end

TOPIC_SIZE = 30
DataMapper.setup(:default, ENV['DATABASE_URL'])
DataMapper.finalize
DataMapper.auto_upgrade!

Chatbot.configure do |config|
  config.bot_id = ENV['GM_BOT_ID'];
end

post '/' do
  message = Chatbot.processMessage(request.body.read)
  add_to_topic(message) unless message.is_command?
end

get '/' do
  @topics = Topic.all
  erb :index
end

get '/topic/:id' do
  @topic = Topic.get(params[:id])
  return "Not Found" if @topic.nil?
  tz = TZInfo::Timezone.get('America/New_York')
  @time = tz.utc_to_local(@topic.created_at)
  erb :topic
end

Chatbot.command '!topic' do |message|
  logger.debug 'Topic command recieved'
  if message.body.empty?
    nil
  else
    topic = Topic.create(:topic => message.body, :creator => message.sender)
    unless topic.saved?
    logger.debug 'RECORD NOT SAVED'
      topic.save
    end
    logger.debug 'NIL ID WTF' if topic.id.nil?
    "#{message.sender} set topic to \"#{message.body}\". #{topic.url}"
  end
end

def add_to_topic(message)
  last_topic = Topic.last
  return if last_topic.nil?
  if last_topic.messages.count() < TOPIC_SIZE
    message = last_topic.messages.new(:sender => message.sender, :body => message.message)
    last_topic.save
  end
end
