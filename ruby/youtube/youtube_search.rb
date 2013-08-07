require 'open-uri'
require 'json'

# YoutubeSearch provides a simple API for searching Youtube and getting the first 3 results
#
# Usage: YoutubeSearch.search_youtube_for("would you look at that") #=> [<url1>, <url2>, <url3>]
#
class YoutubeSearch
  class << self
    def search_youtube_for(user_input)
      query_string = encode_for_url(user_input)
      search_url = generate_search_url(query_string)
      response = make_request_to_url(search_url)
      urls = parse_response(response)
    end

    private

    def encode_for_url(plain_input)
      URI::encode(plain_input)
    end

    def generate_search_url(query_string)
      "http://gdata.youtube.com/feeds/api/videos?max-results=3&alt=json&q=#{query_string}"
    end

    def make_request_to_url(search_url)
      open(search_url).read
    end

    def parse_response(response)
      urls = []

      results = JSON.parse(response)
      results["feed"]["entry"].each do |result|
        urls << result_url(result)
      end

      urls
    end

    def result_url(result)
      result["link"].first["href"].gsub('&feature=youtube_gdata', '')
    end
  end
end
