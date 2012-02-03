class Game < ActiveRecord::Base
  has_many :ratings, :dependent => :destroy
  has_many :results, :dependent => :destroy

  validates :name, :presence => true

  def all_ratings
    ratings.order("value DESC")
  end

  def recent_results
    results.order("created_at DESC").limit(5)
  end

  def top_ratings
    ratings.order("value DESC").limit(5)
  end
end
