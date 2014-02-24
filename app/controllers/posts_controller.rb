class PostsController < ApplicationController
  
  def index
  	
    if params[:tag]
      @posts = Post.tagged_with(params[:tag]).order("hotness desc").page(params[:page]).per(10)
    elsif params[:duration]
      duration = params[:duration]
      case duration
        when 'today'
          @posts = Post.today.order('votes desc').page(params[:page]).per(10)
        when 'week'
          @posts = Post.week.order('votes desc').page(params[:page]).per(10)
        when 'month' 
          @posts = Post.month.order('votes desc').page(params[:page]).per(10)
        when 'year'
          @posts = Post.year.order('votes desc').page(params[:page]).per(10)
        when 'all_time'
      end
      else
      @posts = Post.all.order("hotness desc").page(params[:page]).per(10)
    end
  end

  def new
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
    @post.votes +=1
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

end
