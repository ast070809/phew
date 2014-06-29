ThinkingSphinx::Index.define :post, :with => :active_record do
  indexes user(:username),   :as => :name_of_user
  indexes tribe(:name),      :as => :tribe_name
  indexes :title,            :as => :post_title
  indexes description
  indexes sub_tribe(:name),  :as => :sub_tribe_name

end
