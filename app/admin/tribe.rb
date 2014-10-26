ActiveAdmin.register Tribe do

  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :name, :id, :priority, :avatar
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
  form do |f|
    f.inputs "Tribe Details" do
      f.input :name
      f.input :avatar, as: :file
    end
    f.actions
  end
end
