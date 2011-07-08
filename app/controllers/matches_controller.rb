class MatchesController < ApplicationController
  before_filter :authenticate_user!, :only => [:add_comment, :toggle_vote_on_comment]
  
  respond_to :html
  
  # GET /matches
  # GET /matches.xml
  def index
    @matches = Match.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @matches }
    end
  end

  # GET /matches/1
  # GET /matches/1.xml
  def show
    @match = Match.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @match }
    end
  end

  # GET /matches/new
  # GET /matches/new.xml
  def new
    @match = Match.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @match }
    end
  end

  # GET /matches/1/edit
  def edit
    @match = Match.find(params[:id])
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
    @match = Match.find(params[:id])

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
    @match = Match.find(params[:id])
    @match.destroy

    respond_to do |format|
      format.html { redirect_to(matches_url) }
      format.xml  { head :ok }
    end
  end
  
  def show_comments #TODO: how to handle non-AJAX request? Also, maybe needs to be in comments controller
    @match = Match.find(params[:id])
    @comments = @match.comments.all
    @comments.sort_by!{|comment| comment.magic_ranking} #this may not work with pagination, see http://stackoverflow.com/questions/657654/how-do-you-normally-sort-items-in-rails
    
    respond_to do |format|
        format.html do
            render :partial => "matches/show_comments", :locals => {:match => @match, :comments => @comments}, :layout => false, :status => :created
        end
        format.xml  { render :xml => @match }
    end
  end
  
  def add_comment
    @match = Match.find(params[:id])
    params[:comment][:user_id] = current_user
      comment = @match.comments.create(params[:comment])
      @match.add_comment(comment) #hopefully this isn't necessary, due to the commentable_id and commentable_type being correct
    
      respond_to do |format|
        format.html do
          render :partial => "matches/show_comment", :locals => {:comment => comment}, :layout => false, :status => :created
        end
        format.xml  { render :xml => comment }
      end
  end
  
  def toggle_vote_on_comment
    comment = Comment.find(params[:comment_id]) #TODO: make sure someone can't do crazy shit like vote for every comment on the site with a script
    if current_user.voted_for?(comment)
      #remove that vote
      vote = current_user.votes.find_by_voteable_id(comment.id)
      vote.destroy
    else
      current_user.vote_for(comment)
    end
    
    render :nothing => true
  end
  
  #TODO: make private
    #low rank is good
   

end
