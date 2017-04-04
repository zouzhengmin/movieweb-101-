class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :movies
  has_many :comments
  has_many :movieusergroups
  has_many :favored_movies, :through => :movieusergroups, :source => :movie

  def add_favor?(movie)
    favored_movies.include?(movie)
  end

  def join!(movie)
    favored_movies << movie
  end

  def quit!(movie)
    favored_movies.delete(movie)
  end

end
