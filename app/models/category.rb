class Category < ActiveRecord::Base
  attr_accessible :name, :description, :course

  belongs_to :course
  has_many :assignments

  validates_presence_of :course, :name
end
