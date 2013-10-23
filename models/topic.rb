require 'uri'
require_relative '../lib/shorten'
BASE_URI = "topicbot.herokuapp.com"
TOPIC_CHARS = 85
URL_LENGTH = 65

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

  def url_shortened_topic
    self[:topic].gsub(URI.regexp(['http','https'])) do |uri|
      if (uri.length > URL_LENGTH)
        linkify(Shorten.shorten_uri(uri))
      else
        linkify(uri)
      end
    end
  end

  def linkify(uri)
    return "<a href=#{uri}>#{uri}</a>"
  end
end
