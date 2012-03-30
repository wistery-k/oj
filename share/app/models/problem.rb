class Problem < ActiveRecord::Base
  validates :title,        :presence => true
  validates :statement,    :presence => true
  validates :time_limit,   :presence => true
  validates :memory_limit, :presence => true
  has_many :testcases
end
