class AnimalsController < ApplicationController
  
  before_filter :authenticate_admin!, :except => [:show, :index]
  before_filter :find_animal, :only => [:show, :edit, :update, :destroy]
  
  # GET /animals
  def index
    @animals_ranked = Animal.ranked_by_win_percentage_cached
  end

  # GET /animals/1
  def show
  end

  # GET /animals/new
  def new
    @animal = Animal.new
  end

  # GET /animals/1/edit
  def edit
  end

  # POST /animals
  def create
    @animal = Animal.create(params[:animal])
    respond_to do |format|
      if @animal.save
        format.html { redirect_to(@animal) }
      else
        format.html { render :action => "show_current" }
      end
    end
  end

  # PUT /animals/1
  def update
    respond_to do |format|
      if @animal.update_attributes(params[:animal])
        format.html { redirect_to(@animal, :notice => 'Animal was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /animals/1
  def destroy
    @animal.destroy

    respond_to do |format|
      format.html { redirect_to(animals_url) }
    end
  end
  
  protected
  
  def find_animal
    @animal = Animal.find(params[:id])
  end
end
