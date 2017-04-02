class MoviesController < ApplicationController
before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
before_action :find_movie_and_check_permission, only: [:edit, :update, :destroy]

  def index
    @movies = Movie.all
  end

  def new
    @movie = Movie.new
  end

  def show
    @movie = Movie.find(params[:id])
    @comments = @movie.comments.recent.paginate(:page => params[:page], :per_page => 5)
  end

  def edit
    find_movie_and_check_permission
  end

  def create
    @movie = Movie.new(movie_params)
    @movie.user = current_user
    @movie.user.join!(@movie)
    if @movie.save
      redirect_to movies_path
    else
      render :new
    end
  end

  def update
    find_movie_and_check_permission

    if current_user != @movie.user
      redirect_to root_path, alert: "滚粗！"
    end

    if @movie.update(movie_params)
      redirect_to movies_path, notice: '已成功更新！'
    else
      render :edit
    end
  end

  def destroy
    find_movie_and_check_permission
    @movie.destroy
    redirect_to movies_path, alert: '电影已删除。'
  end

  def join
    @movie = Movie.find(params[:id])
    if !current_user.is_member_of?(@movie)
      current_user.join!(@movie)
      flash[:notice] = "已加入群组!"
    else
      flash[:notice] = "你已是本组成员!"
    end
      redirect_to movie_path(@movie)
  end

  def quit
    @movie = Movie.find(params[:id])
    if current_user.is_member_of?(@movie)
      current_user.quit!(@movie)
      flash[:notice] ="已退出群组！"
    else
      flash[:notice] ="你不是群组成员！"
    end
      redirect_to movie_path(@movie)
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :description)
  end

  def find_movie_and_check_permission
    @movie = Movie.find(params[:id])
    if current_user != @movie.user
      redirect_to root_path, alert: "滚粗！"
    end
  end

end
