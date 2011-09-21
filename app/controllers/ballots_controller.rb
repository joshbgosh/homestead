class BallotsController < ApplicationController
  # GET /ballots
  # GET /ballots.xml
  layout "for_ballot"

  respond_to :html, :xml, :json

  before_filter :authenticate_admin!, :only => [:index, :show, :update, :destroy]
  before_filter :find_ballot, :only => [:show, :show_my_comments, :update, :destroy]

  #TODO: Some ballot stuff might be better to calculate through matches (and cache in matches)

  def index
    @ballots = Ballot.all
  end

  # GET /ballots/1
  def show
  end


  def show_current
    begin
      render_new_ballot and return unless session[:current_match_id] #TODO: do we really want this to happen the first time a user visits us?

      #re-serve existing ballot
      ballot = Ballot.new(:match => Match.find(session[:current_match_id]))
      render_ballot(ballot)
    rescue Animal::NotEnoughAnimalsLoadedException => e
      redirect_to(new_animal_path, :error => NOT_ENOUGH_ANIMALS_ALERT)
    end
  end

  # GET /ballots/new 
  def new
    render_new_ballot
  end



  # POST /ballots
  def create 
    render_new_ballot and return unless session[:current_match_id]

    current_match = Match.find(session[:current_match_id])

    winner_id = params[:winner_id].to_i
    case winner_id
    when current_match.opponent_1.id 
      submitted_ballot = Ballot.create(:winner => current_match.opponent_1, :loser => current_match.opponent_2)
    when current_match.opponent_2.id 
      submitted_ballot = Ballot.create(:winner => current_match.opponent_2, :loser => current_match.opponent_1)
    else
      flash[:alert] = "It looks like you tried to vote using an old ballot. Here's your current ballot to vote on instead."
      redirect_to :action => :show_current and return
    end

    session[:previous_ballot_id] = submitted_ballot.id

    session[:current_match_id] = nil

    render_new_ballot
  end

  # PUT /ballots/1
  def update
    respond_to do |format|
      if @ballot.update_attributes(params[:ballot])
        format.html { redirect_to(@ballot, :notice => 'Ballot was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /ballots/1
  def destroy
    @ballot.destroy

    respond_to do |format|
      format.html { redirect_to(ballots_url) }
    end
  end  

  def show_current_comments
    match_id = session[:current_match_id]
    match = Match.find(match_id)
    render :partial => "ballot_comments_content", :locals => {:match => match}
  end

  def show_my_comments
    respond_to do |format|
      format.html do
        render :partial => "ballot_comment_contents", :locals => {:match => @ballot.match}, :layout => false, :status => :created
      end
    end
  end

  protected

  def find_ballot
    @ballot = Ballot.find(params[:id])
  end

  def render_new_ballot
    begin
      ballot = Ballot.generate_new 
      session[:current_match_id] = ballot.match_id

      render_ballot(ballot)

    rescue Animal::NotEnoughAnimalsLoadedException => e
      flash[:error] = NOT_ENOUGH_ANIMALS_ALERT
      redirect_to(new_animal_path)
    end
  end

  def render_ballot(ballot)
    
    previous_ballot_id = session[:previous_ballot_id]
    if previous_ballot_id
      previous_ballot = Ballot.find(previous_ballot_id)
    else 
      previous_ballot = nil
    end

    #show a special message if it's the user's first time visiting.
    if ! cookies[:been_here_before]
      flash[:notice] = "Click the animal you think will win in the ballot below!"
      cookies[:been_here_before] = true
    end

    respond_to do |format|
      format.html do
        @ballot = ballot
        @previous_ballot = previous_ballot
        render "new"
      end
    end
  end

  NOT_ENOUGH_ANIMALS_ALERT = "We need more animals in the database to create a ballot.
  If you're an admin, add more animals! 
  Otherwise, an admin should be along shortly to set things up."


end
