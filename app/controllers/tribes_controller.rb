class TribesController < ApplicationController 

  def index
    
  end

  def show
    links_per_page = 10
    tribe_id = params[:id]
    @tribes = Tribe.all
    
    # use the tribe name to activate the header
    @tribe = Tribe.find(tribe_id)
    
    # variable to show proper header
    @tribe_show = true
    @post_index = false

    if @tribe
      if params[:duration]
        duration = params[:duration]
        @duration_header = true
        case duration
          when 'current'
            @new_header = true
            @posts = @tribe.posts.order('created_at desc').page(params[:page]).per(links_per_page)
          when 'today'
            @posts = @tribe.posts.today.order('netvotes desc','created_at desc').page(params[:page]).per(links_per_page)
          when 'week'
            @posts = @tribe.posts.week.order('netvotes desc' , 'created_at desc').page(params[:page]).per(links_per_page)
          when 'month' 
            @posts = @tribe.posts.month.order('netvotes desc' , 'created_at desc').page(params[:page]).per(links_per_page)
          when 'year'
            @posts = @tribe.posts.year.order('netvotes desc' , 'created_at desc').page(params[:page]).per(links_per_page)
          when 'all_time'
            @posts = @tribe.posts.order('netvotes desc' , 'created_at desc').page(params[:page]).per(links_per_page)
        end
      elsif params[:host]
          source = params[:host]
          @posts = @tribe.posts.order("hotness desc").page(params[:page]).per(links_per_page)
      else
        @posts = @tribe.posts.order("hotness desc").page(params[:page]).per(links_per_page)
      end
    end
  end

  private 
    def get_tribe(name)
      Tribe.find_by_name(name)
    end
end