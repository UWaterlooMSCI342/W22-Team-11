class StudentNumber < ApplicationRecord
  #student number belongs to a team
  belongs_to :team
  #student number belongs to a user
  belongs_to :user
end
