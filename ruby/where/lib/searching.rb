module Searching
  def where(criteria)
    results = []

    self.each do |elem|
      add_to_results = true

      criteria.each do |criterion, value|
        if value.is_a? Regexp
          add_to_results = false if elem[criterion] !~ value
        else #value is an exact match
          add_to_results = false if elem[criterion] != value
        end
      end

      results << elem if add_to_results
    end

    results
  end
end

class Array
  include Searching
end
