class PostsController < ApplicationController 
  require 'open-uri'
  require 'nokogiri'
  require 'fastimage'
  has_mobile_fu_for :index, :upvote, :downvote
  before_filter :authenticate, except: [:index, :show, :search]  
  
  include Feed

  def index
    links_per_page = 10
      
    @post_index = true
    if params[:tag]
      @posts = Post.tagged_with(params[:tag]).order("hotness desc").page(params[:page]).per(links_per_page)
    elsif params[:duration]
      duration = params[:duration]
        @duration_header = true
        case duration
          when 'current'
            @new_header = true
            @posts = Post.all.order('created_at desc').page(params[:page]).per(links_per_page)
          when 'today'
            @posts = Post.today.order('netvotes desc','created_at desc').page(params[:page]).per(links_per_page)
          when 'week'
            @posts = Post.week.order('netvotes desc' , 'created_at desc').page(params[:page]).per(links_per_page)
          when 'month' 
            @posts = Post.month.order('netvotes desc' , 'created_at desc').page(params[:page]).per(links_per_page)
          when 'year'
            @posts = Post.year.order('netvotes desc' , 'created_at desc').page(params[:page]).per(links_per_page)
          when 'all_time'
            @posts = Post.all.order('netvotes desc' , 'created_at desc').page(params[:page]).per(links_per_page)
        end
    elsif params[:host]
        source = params[:host]
        @posts = Post.order("hotness desc").page(params[:page]).per(links_per_page)
    else
      @posts = Post.all.order("hotness desc").page(params[:page]).per(links_per_page)
    end
    

  end

  ## Controller for mobile
  def new_temp
  end
  
  def new
  	@url = params[:url]
    
    if @url.present?
      @title = get_title(@url)
      @source = get_host(@url)
      @descrip = get_descrip(@url)
    end
    @post = Post.new
    @tribes = Tribe.all
    @trending_tribes = TrendingTribe.all

    #@images = get_images(@url)
    ##It will be better to move this job in background
  end

  def add_post_directly
    @url = params[:link]

    post = current_user.posts.new

    if @url.present?
      
      @title = get_title(@url)
      @source = get_host(@url)
      @descrip = get_descrip(@url)
      
      post.link = @url
      post.title = @title
      post.source = @source
      post.description = @descrip
      post.tag_list.add(params[:tag_list], parse: true)
      
      #assigning the tribe
      tribe = Tribe.find(params[:tribe])
      post.tribe_id = tribe.id

      #image link
      @image_link = get_images(@url)
      post.pic = get_image_from_url(@image_link)

      if post.save
        Post.refresh_hotness(post)
        flash[:success] = 'Successfully posted'
        redirect_to root_path
      else
        flash[:error] = 'Some error occurred'
        redirect_to new_post_path
      end
    else
      flash[:error] = 'Link not provided, please provide the link and try again'
      redirect_to root_path
    end

  end

  def create
    post = current_user.posts.create(post_params)
  	
    #assigning the tribe
    if params[:post][:tribe]
      tribe = Tribe.find(params[:post][:tribe])
      post.tribe_id = tribe.id
    end
    
    #assigning the sub tribe if present
    if params[:post][:sub_tribe]
      stribe = SubTribe.find(params[:post][:sub_tribe])
      post.sub_tribe_id = stribe.id
    end
    #assigning the source
    @uri = URI.parse(params[:post][:link])
    post.source = @uri.host

    #image link
    @image_link = get_images(@uri)
    post.pic = get_image_from_url(@image_link)
    

    if post.save
      Post.refresh_hotness(post)
      flash[:success] = 'Successfully posted'
      redirect_to root_path
  	else
      flash[:error] = 'Some error occurred'
      redirect_to new_post_path
  	end
  end

  def show
    @post = Post.friendly.find(params[:id])
    if request.path != post_path(@post)
      redirect_to @post, status: :moved_permanently
    end

    @post_show = true
    @tribes = Tribe.all
    @type = 'top'
    if params[:type]
      type = params[:type]
      case type
        when 'best'
          @type = 'best'
          @root_comments = @post.root_comments.order('hotness desc')
        when 'latest'
          @type = 'latest'
          @root_comments = @post.root_comments.order('created_at desc')
        else
          @root_comments = @post.root_comments.order('netvote desc', 'created_at desc')
      end
    else
      @root_comments = @post.root_comments.order('netvote desc', 'created_at desc')
    end
  end

  def search
    links_per_page = 10
    @posts= Post.search(params[:searchquery]).page(params[:page]).per(links_per_page)
  end

  def delete
    @post = Post.friendly.find(params[:id])
    @post.destroy
    redirect_to :back
  end

  def add_comment
    if user_signed_in?
      post_id = params[:post_id]
      comment = params[:comment]
      @post = Post.friendly.find(post_id)
      @user_who_commented = current_user
      @comment = Comment.build_from( @post, @user_who_commented.id, comment )
      if @comment.save
          flash[:success] = "Successfully saved"
          Noti.add_comment_noti(post_id, current_user.id)
      else
        @err = @comment.errors
      end
      redirect_to :back
    else
      redirect_to '/users/sign_in'
    end
  end

  def upvote
    @post = Post.friendly.find(params[:id])
    @post.liked_by current_user
    Post.refresh_votes(@post)
    if @post.save
      Post.refresh_hotness(@post)
      respond_to do |format|
        format.html {redirect_to :back}
        format.mobilejs 
        format.js
      end
    end
  end
  
  def downvote
    @post = Post.friendly.find(params[:id])
    @post.downvote_from current_user
    Post.refresh_votes(@post)
    if @post.save
      Post.refresh_hotness(@post)
      respond_to do |format|
        format.html {redirect_to :back}
        format.mobilejs
        format.js 
      end
    end

  end

  def add_child_comment
    if user_signed_in?
      post_id = params[:post_id]
      parent_id = params[:parent_id]
      comment = params[:comment]

      @post = Post.friendly.find(post_id)
      parent_comment = Comment.find(parent_id)


      @user_who_commented = current_user
      @comment = Comment.build_from(@post, @user_who_commented.id, comment)
      
      if @comment.save
        @comment.move_to_child_of(parent_comment)
        
        flash[:success] = "Successfully saved"
      else
        flash[:warning] = "#{@comment.errors.full_messages}"
      end
      redirect_to :back
    else
      redirect_to '/users/sign_in'
    end
  end

  def report_post
    post_id = params[:id]
    post = Post.friendly.find(post_id)
    r = post.reports.find_or_create_by(user_id: current_user.id)
    if r
      flash[:success] = "Reported Successfully"
    else
      flash[:error] = "Some error occured"
    end
    redirect_to :back
  end



  private 

    def post_params
	  	params.require(:post).permit(:title, :link,:description, :tag_list, :pic)
	  end
    
    def get_title(link)
      doc = Nokogiri::HTML(open(link))
      if doc.at_css("h1")
        doc.at_css("h1").text 
      else
        ""
      end
    end

    def get_host(link)
      s = URI.parse(link)
      source = s.host
      if source
        return source
      else
        return "no source found"
      end
    end

    def get_image_from_url(url)
      begin 
        open(url)
      rescue 
        ""
      end
    end

    def get_descrip(link)
      page = Nokogiri::HTML(open(link)) 
      descp = page.css("meta[name='description']")[0]
      if descp
        description = descp['content']
      else 
        description = "none"
      end

    end

    def process_page(url)
      doc = Nokogiri(open(url))
    end

    def process_images(doc)
      images = doc.css('img')
    end


    def get_images(url)
      page = Nokogiri::HTML(open(url)) 
      chk_og = page.css("meta[property='og:image']")[0]
      if chk_og
        image_link = chk_og['content']
      else 
        image_link = get_first_elligible_image(page)
      end
    end

    def get_first_elligible_image(page)
      img_pth_content = page.xpath("//img[not(ancestor::*[contains(@id, 'sidebar') or contains(@id, 'comment') or contains(@id, 'footer') or contains(@id, 'header')]) and ancestor::*[contains(@id, 'content')]]/@src")
      img_pth_all = page.xpath("//img[not(ancestor::*[contains(@id, 'sidebar') or contains(@id, 'comment') or contains(@id, 'footer') or contains(@id, 'header')])]/@src")
      
      img_paths = if img_pth_content.empty? then img_pth_all else img_pth_content end

      res_path = ""
      img_paths.each do |pth|
          width, len= get_size(pth)
          res_path = pth
          if width>100 && len >100 && (width/len)<3
            break
          else 
            res_path = ""
          end
      end
      res_path
    end

    def get_size(img_pth)
      begin
        size = FastImage.size(img_pth,:raise_on_failure=>true, :timeout=>2.0)
        width = size[0]
        len = size[1]
      rescue
        size = [1,1]
        width = size[0]
        len = size[1]
      end
      return width, len
    end

    def authenticate
      if !user_signed_in?
        redirect_to new_user_session_path
      end
    end

    def get_tribe(tribe)
      Tribe.find_by(name: tribe)
    end

    def get_feed
    end
end
