class PostsController < ApplicationController
  require 'open-uri'
  require 'nokogiri'

  def index
    links_per_page = 10
    if params[:tag]
      @posts = Post.tagged_with(params[:tag]).order("hotness desc").page(params[:page]).per(links_per_page)
    elsif params[:duration]
      duration = params[:duration]
      case duration
        when 'current'
          @posts = Post.all.order('created_at desc').page(params[:page]).per(links_per_page)
        when 'today'
          @posts = Post.today.order('votes desc').page(params[:page]).per(links_per_page)
        when 'week'
          @posts = Post.week.order('votes desc').page(params[:page]).per(links_per_page)
        when 'month' 
          @posts = Post.month.order('votes desc').page(params[:page]).per(links_per_page)
        when 'year'
          @posts = Post.year.order('votes desc').page(params[:page]).per(links_per_page)
        when 'all_time'
          @posts = Post.all.order('votes desc').page(params[:page]).per(links_per_page)
      end
      else
      @posts = Post.all.order("hotness desc").page(params[:page]).per(links_per_page)
    end
  end

  def new
  	@url = params[:url]
    @title = get_link_details(@url)
    @post = Post.new
    @tribe = Tribe.all
  end

  def create
    post = current_user.posts.create(post_params)
  	tribe = Tribe.find(params[:post][:tribe])
    post.tribe_id = tribe.id
    
    if post.save
      Post.refresh_hotness(post)

      redirect_to root_path
  	else
      flash[:error] = 'Some error occurred'
      redirect_to new_post_path
  	end
  end

  def show
    @post = Post.find(params[:id])
    @root_comments = @post.root_comments
    @all_comments = @post.comment_threads
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
    @post.votes = @post.votes+1
    if @post.save
      Post.refresh_hotness(@post)
    end
    redirect_to :back
  end
  
  def downvote
    @post = Post.find(params[:id])
    @post.downvote_from current_user
    @post.votes -=1
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
	  	params.require(:post).permit(:title, :link,:description, :tag_list)
	  end
    
    def get_link_details(link)
      doc = Nokogiri::HTML(open(link))
      doc.at_css("h1").text
    end
end
