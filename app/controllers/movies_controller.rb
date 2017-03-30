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
  end

  def edit
    find_movie_and_check_permission
  end

  def create
    @movie = Movie.new(movie_params)
    @movie.user = current_user
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
