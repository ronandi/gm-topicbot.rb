require 'chatbot'
require 'sinatra'
require 'data_mapper'
require './models/topic'
require './models/message'
require 'tzinfo'
require 'logger'

logger = Logger.new(STDOUT)

before do
  logger.level = Logger::DEBUG
end

helpers do
  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [ENV['TOPICBOT_USER'], ENV['TOPICBOT_PASSWORD']]
  end
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
  protected!
  @topics = Topic.all
  erb :index
end

get '/stats' do
  protected!
  File.new('private/stats.html').readlines
end

get '/topic/:id' do
  protected!
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
