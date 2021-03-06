# /app/helpers/devise_helper.rb
 
module DeviseHelper
  
  def devise_error_messages!
    return '' if resource.errors.empty?
    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t('errors.messages.not_saved',
    count: resource.errors.count,
    resource: resource.class.model_name.human.downcase)
     
    html = <<-HTML
    <div class="alert alert-danger">
    <button type="button" class="close" data-dismiss="alert">x</button>
    <h5>#{sentence}</h5>
    #{messages}
    </div>
    HTML
     
    html.html_safe
  end

  def image_url(source)    
    "#{root_url}#{image_path(source)}"
  end
end