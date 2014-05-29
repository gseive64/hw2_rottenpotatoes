class MoviesController < ApplicationController

 

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    redirect_needed = false

    if session.key?(:sorting_settings)
      #get sorting settings
      sorting_settings = session[:sorting_settings]
    end
    if session.key?(:filtering_settings)
      #get filtering settings
      filtering_settings = session[:filtering_settings]
    else
      filtering_settings = {"G"=>"true","PG"=>"true", "PG-13"=>"true", "R"=>"true"}
    end

    # what comes from params overrides session
    if params.key?(:sort)
      sorting_settings = params[:sort]
    else
      if session.key?(:sorting_settings)
        redirect_needed = true
        params[:sort] = sorting_settings
      end
    end

    if params.key?("ratings")
      filtering_settings = params["ratings"]
     # if session.key?(:filtering_settings)
      #  redirect_needed = true
     #   params["ratings"] = filtering_settings
     # end
    end

    if redirect_needed
      redirect_to movies_path(params)
    end
    
     @all_ratings = Movie.movie_ratings
    #if params["ratings"]== nil
     # @checked_ratings 
    #else
    #  @checked_ratings = params["ratings"]
    #end
    @checked_ratings = filtering_settings
    ratings_selected = @checked_ratings.keys
    @movies = Movie.where({rating: ratings_selected})
    # User.where({name: ["Alice", "Bob"]})
    # SELECT * FROM users WHERE name IN ('Alice', 'Bob')

    if !sorting_settings.nil?
      @movies = @movies.order(sorting_settings).all
      
      # Set CSS class
      if sorting_settings == 'title'
        @title_highlight = "hilite"
      else
        @title_highlight = "normal"
      end
      if sorting_settings == 'release_date'
        @release_date_highlight = "hilite"
      else
        @release_date_highlight = "normal"
      end
      #raise params.inspect
    else
      #@movies = Movie.all
    end  
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
