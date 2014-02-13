class PostsController < ApplicationController
  def index
  	@posts = Post.all
  end

  def new
  	@post = Post.new
  end

  def create
  	post = Post.create(post_params)
  	if post
  		redirect_to root_path
  	else
  		redirect_to new_path
  	end
  end

  def show
    @post = Post.find(params[:id])
    @root_comments = @post.root_comments
    @all_comments = @post.comment_threads
  end

  def add_comment
    if user_signed_in?
      post_id = params[:pid]
      comment = params[:comment]
      @post = Post.find(post_id)
      @user_who_commented = current_user
      @comment = Comment.build_from( @post, @user_who_commented.id, comment )
      if @comment.save
     
      else
        @err = @comment.errors
      end
      redirect_to :back
    else
      redirect_to '/users/sign_in'
    end
  end

  def add_child_comment
  end

  private 
  	def post_params
	  	params.require(:post).permit(:title, :link,:description)
	  end

end
