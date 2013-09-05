require 'sinatra'
require 'net/http'
require 'json'

BOT_ID = ENV['GM_BOT_ID'];
API_KEY = ENV['GM_API_KEY'];
URI = 'https://api.groupme.com/v3/bots/post';

post '/' do
  message = validate_message(request.body.read)
  send_message(message.topic_message) if message.is_topic_message?
end

def validate_message(msg)
  Message.new((JSON.parse(msg) rescue {})) #If an exception occurs parsing, use {}
end

def send_message(msg)
  Net::HTTP.post_form(URI, { "bot_id" => BOT_ID, "text" => msg })
end
