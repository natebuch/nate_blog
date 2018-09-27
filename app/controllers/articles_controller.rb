class ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :update, :show, :destroy]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]


  def new
  	@article = Article.new
  end

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  def edit
    @article = set_article
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save
      flash[:success] = "Article has been successfully created."
      redirect_to article_path(@article)
    else
      render 'new'
    end
  end

def update
  @article = set_article
  if @article.update(article_params)
    flash[:success] = "Article was successfully updated"
    redirect_to article_path(@article)
  else
    render 'edit'
  end
end

  def show
    @article = set_article
  end

  def destroy
    @article = set_article
    @article.destroy
    flash[:danger] = "Article was deleted"
    redirect_to articles_path
  end

  
  private

    def set_article
      @article = Article.find(params[:id])

    end

    def article_params
      params.require(:article).permit(:title, :description, category_ids: [])
    end

    def require_same_user
      if current_user != @article.user and !current_user.admin?
        flash[:danger] = "You may only manage your own articles"
        redirect_to root_path
      end
    end
end