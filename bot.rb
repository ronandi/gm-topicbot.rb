require 'chatbot'
require 'sinatra'
Chatbot.configure do |config|
  config.bot_id = ENV['GM_BOT_ID'];
end

post '/' do
  Chatbot.processMessage(request.body.read)
end

Chatbot.command '!topic' do |message|
  puts 'topic message recieved'
  if message.message.nil?
    puts 'but its empty'
    nil
  else
    puts 'sending to gm'
    "#{message.sender} set topic to  #{message.message}"
  end
end
