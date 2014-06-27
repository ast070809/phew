class Activity < ActiveRecord::Base
  belongs_to :verb, polymorphic: true
  belongs_to :user
end
