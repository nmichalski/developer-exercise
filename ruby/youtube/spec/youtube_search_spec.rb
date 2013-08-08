require 'youtube_search'

describe YoutubeSearch do
  context 'search_youtube_for' do
    before(:all) do
      @sample_youtube_json_response = File.read('spec/youtube_search_sample_json.json')
    end

    before(:each) do
      YoutubeSearch.stub(:make_request_to_url).and_return(@sample_youtube_json_response)
    end

    it 'should return 3 results' do
      urls = YoutubeSearch.search_youtube_for('day9')
      urls.size.should == 3
    end

    it 'should return valid urls' do
      urls = YoutubeSearch.search_youtube_for('day9 trumpets')
      urls.each do |url|
        url.should =~ /http\:\/\/www.youtube.com\/watch\?v\=/
      end
    end
  end
end
