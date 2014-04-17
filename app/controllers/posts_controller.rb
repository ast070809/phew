class PostsController < ApplicationController 
  require 'open-uri'
  require 'nokogiri'
  require 'fastimage'
  
  before_filter :authenticate, except: [:index, :show]  
  
  def index
    links_per_page = 10
    @tribes = Tribe.all

    @post_index = true
    if params[:tag]
      @posts = Post.tagged_with(params[:tag]).order("hotness desc").page(params[:page]).per(links_per_page)
    elsif params[:duration]
      duration = params[:duration]
        case duration
          when 'current'
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

  def new
  	@url = params[:url]
    
    if @url.present?
      @title = get_title(@url)
      @source = get_host(@url)
      @descrip = get_descrip(@url)
    end
    @post = Post.new
    @tribe = Tribe.all
    #@images = get_images(@url)

    ##It will be better to move this job in background

  end

  def create
    post = current_user.posts.create(post_params)
  	
    #assigning the tribe
    tribe = Tribe.find(params[:post][:tribe])
    post.tribe_id = tribe.id
    
    #assigning the source
    @uri = URI.parse(params[:post][:link])
    post.source = @uri.host


    #image link
    @image_link = get_images(@uri)
    post.pic = get_image_from_url(@image_link)

    if post.save
      Post.refresh_hotness(post)

      redirect_to root_path, notice: 'Successfully posted'
  	else
      flash[:error] = 'Some error occurred'
      redirect_to new_post_path
  	end
  end

  def show
    @post = Post.find(params[:id])
    
    if params[:type]
      type = params[:type]
      case type
        when 'best'
          @root_comments = @post.root_comments.order('hotness desc')
        else
          @root_comments = @post.root_comments.order('netvote desc', 'created_at desc')
      end
    end
    @all_comments = @post.comment_threads
    @root_comments = @post.root_comments.order('netvote desc', 'created_at desc')
  end

  def delete
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to :back
  end

  def add_comment
    if user_signed_in?
      post_id = params[:post_id]
      comment = params[:comment]
      @post = Post.find(post_id)
      @user_who_commented = current_user
      @comment = Comment.build_from( @post, @user_who_commented.id, comment )
      if @comment.save
          flash[:notice] = "Successfully saved"
      else
        @err = @comment.errors
      end
      redirect_to :back
    else
      redirect_to '/users/sign_in'
    end
  end

  def upvote
    @post = Post.find(params[:id])
    @post.liked_by current_user
    @post.netvotes +=1
    if @post.save
      Post.refresh_hotness(@post)
    end
    redirect_to :back
  end
  
  def downvote
    @post = Post.find(params[:id])
    @post.downvote_from current_user
    @post.netvotes -=1
    if @post.save
      Post.refresh_hotness(@post)
    end
    redirect_to :back
  end

  def add_child_comment
    if user_signed_in?
      post_id = params[:post_id]
      parent_id = params[:parent_id]
      comment = params[:comment]

      @post = Post.find(post_id)
      parent_comment = Comment.find(parent_id)


      @user_who_commented = current_user
      @comment = Comment.build_from(@post, @user_who_commented.id, comment)
      
      if @comment.save
        @comment.move_to_child_of(parent_comment)
        flash[:notice] = "Successfully saved"
      else
        flash[:notice] = "#{@comment.errors.full_messages}"
      end
      redirect_to :back
    else
      redirect_to '/users/sign_in'
    end
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
      open(url)
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
end
