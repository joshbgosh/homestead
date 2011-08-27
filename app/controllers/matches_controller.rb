class MatchesController < ApplicationController
  
  before_filter :authenticate_admin!, :only => [:index, :show, :new, :edit, :create, :update, :destroy]
  before_filter :authenticate_user!, :only => [:add_comment, :toggle_vote_on_comment]
  before_filter :find_match, :only => [:show, :edit, :update, :destroy, :show_comments, :add_comment]
  
  respond_to :html
  
  # GET /matches
  def index
    @matches = Match.all
  end

  # GET /matches/1
  def show
  end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit
  end

  # POST /matches
  # POST /matches.xml
  def create
    @match = Match.new(params[:match])

    respond_to do |format|
      if @match.save
        format.html { redirect_to(@match, :notice => 'Match was successfully created.') }
        format.xml  { render :xml => @match, :status => :created, :location => @match }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @match.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /matches/1
  # PUT /matches/1.xml
  def update
    respond_to do |format|
      if @match.update_attributes(params[:match])
        format.html { redirect_to(@match, :notice => 'Match was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @match.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1
  # DELETE /matches/1.xml
  def destroy
    @match.destroy

    respond_to do |format|
      format.html { redirect_to(matches_url) }
      format.xml  { head :ok }
    end
  end
  
  def show_comments #TODO: how to handle non-AJAX request? Also, maybe needs to be in comments controller
    @comments = @match.get_ranked_comments
    
    respond_to do |format|
        format.html do
            render :partial => "matches/show_comments", :locals => {:match => @match, :comments => @comments}, :layout => false, :status => :created
        end
        format.xml  { render :xml => @match }
    end
  end
  
  def add_comment
    params[:comment][:user_id] = current_user.id
    comment = @match.comments.create(params[:comment])
      #@match.add_comment(comment) #hopefully this isn't necessary, due to the commentable_id and commentable_type being correct
      respond_to do |format|
        format.html do
          render :partial => "matches/show_comment", :locals => {:comment => comment, :hide_at_first => true}, :layout => false, :status => :created
        end
        format.xml  { render :xml => comment }
      end
  end
  
  def toggle_vote_on_comment
    comment = Comment.find(params[:comment_id]) #TODO: make sure someone can't do crazy shit like vote for every comment on the site with a script
    comment.toggle_vote(current_user)
    render :nothing => true
  end
  
  
  
      
  protected
  
  def find_match
    @match = Match.find(params[:id])
  end
   

end
