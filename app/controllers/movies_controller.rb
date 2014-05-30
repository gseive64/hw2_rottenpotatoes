class MoviesController < ApplicationController

 

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    redirect_needed = false
    @all_ratings = Movie.movie_ratings

    if session.key?(:sorting_settings)
      #get sorting settings
      sorting_settings = session[:sorting_settings]
    end
    if session.key?(:filtering_settings)
      #get filtering settings
      filtering_settings = session[:filtering_settings]
    else
      filtering_settings = Hash.new
      @all_ratings.each {|e| filtering_settings[e] = "true"}
    end

    # what comes from params overrides session
    if params.key?(:sort)
      sorting_settings = params[:sort]
    elsif session.key?(:sorting_settings)
      redirect_needed = true
      params[:sort] = sorting_settings
    end

    if params.key?(:ratings)
      filtering_settings = params[:ratings]
    elsif session.key?(:filtering_settings)
      redirect_needed = true
      params[:ratings] = filtering_settings
    end

    if redirect_needed
      redirect_to movies_path(params)
    end
    
    @checked_ratings = filtering_settings
    @movies = Movie.where({rating: filtering_settings.keys}).order(sorting_settings)
    # User.where({name: ["Alice", "Bob"]})
    # SELECT * FROM users WHERE name IN ('Alice', 'Bob')

    # Set CSS class
    @title_highlight = sorting_settings == 'title' ? "hilite" : "normal"
    @release_date_highlight = sorting_settings == 'release_date' ? "hilite" : "normal"  

    # Preserve in Session
    session[:sorting_settings] = sorting_settings
    session[:filtering_settings] = filtering_settings
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
