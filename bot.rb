require 'chatbot'
require 'sinatra'
Chatbot.configure do |config|
  config.bot_id = ENV['GM_BOT_ID'];
end

post '/' do
  Chatbot.processMessage(request.body.read)
end

Chatbot.command '!topic' do |message|
  return nil if message.message.nil?
  return "#{message.sender} set topic to  #{message.message}"
end
