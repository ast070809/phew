class SubTribesController < ApplicationController 

  def index
  end

  def show
    links_per_page = 10
    tribe_id = params[:id]
    # use the tribe name to activate the header
    @st_tribe = SubTribe.find(tribe_id)
    
    # variable to show proper header
    @st_tribe_show = true
    @post_index = false

    if @st_tribe
      if params[:duration]
        duration = params[:duration]
        @duration_header = true
        case duration
          when 'current'
            @new_header = true
            @posts = @st_tribe.posts.order('created_at desc').page(params[:page]).per(links_per_page)
          when 'today'
            @posts = @st_tribe.posts.today.order('netvotes desc','created_at desc').page(params[:page]).per(links_per_page)
          when 'week'
            @posts = @st_tribe.posts.week.order('netvotes desc' , 'created_at desc').page(params[:page]).per(links_per_page)
          when 'month' 
            @posts = @st_tribe.posts.month.order('netvotes desc' , 'created_at desc').page(params[:page]).per(links_per_page)
          when 'year'
            @posts = @st_tribe.posts.year.order('netvotes desc' , 'created_at desc').page(params[:page]).per(links_per_page)
          when 'all_time'
            @posts = @st_tribe.posts.order('netvotes desc' , 'created_at desc').page(params[:page]).per(links_per_page)
        end
      elsif params[:host]
          source = params[:host]
          @posts = @st_tribe.posts.order("hotness desc").page(params[:page]).per(links_per_page)
      else
        @posts = @st_tribe.posts.order("hotness desc").page(params[:page]).per(links_per_page)
      end
    end
  end

  private 
    def get_tribe(name)
      Tribe.find_by_name(name)
    end
end