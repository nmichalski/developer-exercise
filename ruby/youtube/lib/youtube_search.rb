require 'open-uri'
require 'json'

# YoutubeSearch provides a simple API for searching Youtube and getting the first 3 results
#
# Usage: YoutubeSearch.search_youtube_for("would you look at that") #=> [<url1>, <url2>, <url3>]
#
class YoutubeSearch
  class << self
    def search_youtube_for(query_string)
      search_url = generate_search_url(query_string)
      response = make_request_to_url(search_url)
      extract_urls_from_response(response)
    end

    private

    def generate_search_url(query_string)
      encoded_query_string = URI::encode(query_string)
      "http://gdata.youtube.com/feeds/api/videos?max-results=3&alt=json&q=#{encoded_query_string}"
    end

    def make_request_to_url(search_url)
      open(search_url).read
    end

    def extract_urls_from_response(response)
      results = JSON.parse(response)
      results['feed']['entry'].collect{|result| result_url(result)}
    end

    def result_url(result)
      result['link'].first['href']
    end
  end
end
