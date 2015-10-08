class Search < ActiveRecord::Base
	has_many :results
	def test
		puts self.hashtag
	end
end
