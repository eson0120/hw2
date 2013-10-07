class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
	@sort_by = params[:o]
    @all_ratings = ['G','PG','PG-13','R']
	@selected_ratings = params[:ratings] || session[:ratings] || {}
	@movies = Movie.find_all_by_rating(@selected_ratings.keys)
	session[:ratings] = @selected_ratings    

	if @sort_by == 'title'
		@movies = @movies.sort_by{|x| x.title}
	elsif @sort_by == 'release_date'
		@movies = @movies.sort_by{|x| x.release_date}
	else
      	@movies = Movie.all
    end

	sort = params[:o] || session[:o]
	if params[:o] != session[:o]
      	session[:o] = sort
      	redirect_to :o => sort, :ratings => @selected_ratings and return
    end

    #redirect_to movies_path(:ratings => @selected_ratings) and return

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
