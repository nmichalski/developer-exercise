require 'searching'

describe Searching do
  context "where" do
    before(:all) do
      @boris   = {:name => 'Boris The Blade',
                  :quote => "Heavy is good. Heavy is reliable. If it doesn't work you can always hit them.",
                  :title => 'Snatch',
                  :rank => 4}
      @charles = {:name => 'Charles De Mar',
                  :quote => 'Go that way, really fast. If something gets in your way, turn.',
                  :title => 'Better Off Dead',
                  :rank => 3}
      @wolf    = {:name => 'The Wolf',
                  :quote => 'I think fast, I talk fast and I need you guys to act fast if you wanna get out of this',
                  :title => 'Pulp Fiction',
                  :rank => 4}
      @glen    = {:name => 'Glengarry Glen Ross',
                  :quote => "Put. That coffee. Down. Coffee is for closers only.",
                  :title => "Blake",
                  :rank => 5}

      @fixtures = [@boris, @charles, @wolf, @glen]
    end

    it 'should return results from exact matches' do
      @fixtures.where(:name => 'The Wolf').should == [@wolf]
    end

    it 'should return results from partial matches (regex)' do
      @fixtures.where(:title => /^B.*/).should == [@charles, @glen]
    end

    it 'should return mutliple results from exact matches' do
      @fixtures.where(:rank => 4).should == [@boris, @wolf]
    end

    it 'should return results from multiple criteria' do
      @fixtures.where(:rank => 4, :quote => /get/).should == [@wolf]
    end

    it 'should return results from chained calls' do
      @fixtures.where(:quote => /if/i).where(:rank => 3).should == [@charles]
    end
  end
end
