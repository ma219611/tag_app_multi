class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update]
  # before_action :set_post_form, only: [:edit]
  before_action :set_post_form, only: [:edit, :update]
  # ★↑updateでも呼び出すと、画像新しく選び直さなくても更新できる★

  def index
    @posts = Post.all
  end

  def new
    @post_form = PostForm.new
  end

  def create

  binding.pry
    @post_form = PostForm.new(post_form_params)
    if @post_form.valid?
      @post_form.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @post_form.tag_name = @post.tags.first&.tag_name
  end

  def update
    # @post_form = PostForm.new(post_form_params)
    # ★↑これ消すと、画像新しく選び直さなくても更新できる★

    if @post_form.valid?

      # 第一引数：post_form_paramsにユーザーが入力した編集したい情報が含まれている
      # 第二引数：@postは編集したい元々のレコード
      @post_form.update(post_form_params, @post)
      redirect_to root_path
    else
      render :edit
    end
  end

  def search
    return nil if params[:keyword] == ""
    tag = Tag.where(['tag_name LIKE ?', "%#{params[:keyword]}%"] )
    render json:{ keyword: tag }
  end

  private
  def post_form_params
    a = params.require(:post_form).permit(:text, tag_names: [])
    b = params.require(:post_form).permit(:image)
    a.merge(b)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def set_post_form
    # @postの情報を取得し、@post_formとしてインスタンス生成し直す
    post_attributes = @post.attributes
    post_attributes[:image] = @post.image
    # ★↑これ付け足すと、画像新しく選び直さなくても更新できる★
    @post_form = PostForm.new(post_attributes)
  end

end
