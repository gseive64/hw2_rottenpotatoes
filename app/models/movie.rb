class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date

  def self.movie_ratings
  	return ['G', 'PG', 'PG-13', 'R']
  end

end
