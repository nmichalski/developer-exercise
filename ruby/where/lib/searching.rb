module Searching
  def where(criteria)
    self.select do |elem|
      criteria.all? do |criterion, value|
        if value.is_a?(Regexp)
          elem[criterion] =~ value
        else
          elem[criterion] == value
        end
      end
    end
  end
end

class Array
  include Searching
end
