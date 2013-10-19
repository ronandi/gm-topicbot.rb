require 'chatbot'
require 'sinatra'
require 'data_mapper'
require './models/topic'
require './models/message'

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

get '/topic/:id' do
  @topic = Topic.get(params[:id])
  erb :topic
end

Chatbot.command '!topic' do |message|
  if message.body.empty?
    nil
  else
    topic = Topic.create(:topic => message.body, :creator => message.sender)
    "#{message.sender} set topic to  \"#{message.body}\". Archive: #{topic.url}"
  end
end

def add_to_topic(message)
  last_topic = Topic.last
  if last.topic.count(:comments) < TOPIC_SIZE
    message = Topic.messages.new(:sender => message.sender, :body => message.body)
    last_topic.save
  end
end
