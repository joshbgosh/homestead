class MatchesController < ApplicationController
  before_filter :authenticate_admin!, :only => [:index, :show, :edit, :create, :update, :destroy]
  before_filter :authenticate_user!, :only => [:add_comment]
  before_filter :find_match, :only => [:show, :edit, :update, :destroy, :show_comments, :add_comment]
 
  respond_to :html
  
  # GET /matches
  def index
    @matches = Match.all
  end

  # GET /matches/1
  def show
  end

  # GET /matches/1/edit
  def edit
  end

  # POST /matches
  def create
    @match = Match.new(params[:match])

    respond_to do |format|
      if @match.save
        format.html { redirect_to(@match, :notice => 'Match was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /matches/1
  def update
    respond_to do |format|
      if @match.update_attributes(params[:match])
        format.html { redirect_to(@match, :notice => 'Match was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /matches/1
  def destroy
    @match.destroy

    respond_to do |format|
      format.html { redirect_to(matches_url) }
    end
  end
  
  def add_comment
    params[:comment][:user_id] = current_user.id
    comment = @match.comments.create(params[:comment])
      respond_to do |format|
        format.html do
          render :partial => "comments/show", :locals => {:comment => comment, :hide_at_first => true}, :layout => false, :status => :created
        end
      end
  end
  

      
  protected
  
  def find_match
    @match = Match.find(params[:id])
  end
   

end
