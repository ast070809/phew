class PostsController < ApplicationController
  def index
  	@posts = Post.all.order("hotness desc")
  end

  def new
  	@post = Post.new
  end

  def create
    post = current_user.posts.create(post_params)
  	if post.save
  		redirect_to root_path
  	else
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
    Post.refresh_hotness(@post)
    redirect_to :back
  end
  
  def downvote
    @post = Post.find(params[:id])
    @post.downvote_from current_user
    Post.refresh_hotness(@post)
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
	  	params.require(:post).permit(:title, :link,:description)
	  end

end
