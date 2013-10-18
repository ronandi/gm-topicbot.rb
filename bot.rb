require 'chatbot'
require 'sinatra'
Chatbot.configure do |config|
  config.bot_id = ENV['GM_BOT_ID'];
end

post '/' do
  Chatbot.processMessage(request.body.read)
end

Chatbot.command '!topic' do |message|
  if message.body.empty?
    nil
  else
  if message.body.empty?
    nil
  else
    "#{message.sender} set topic to  #{message.body}"
  end
end
