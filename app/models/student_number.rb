class StudentNumber < ApplicationRecord

  validates_length_of :number, maximum: 8
  validates_uniqueness_of :number, :case_sensitive => false
  validates_presence_of :number
  validates_format_of :number, with: ^\d+$

  belongs_to :team
  belongs_to :user
end
