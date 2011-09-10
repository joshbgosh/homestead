class BattlesController < ApplicationController
  # GET /battles
  # GET /battles.xml
  layout "for_battle"
  
  respond_to :html, :xml, :json
  
  before_filter :authenticate_admin!, :only => [:index, :show, :update, :destroy]
  before_filter :find_battle, :only => [:show, :update, :destroy]
  
  #TODO: Some battle stuff might be better to calculate through matches (and cache in matches)
  
  def index
    @battles = Battle.all
  end

  # GET /battles/1
  def show
    #TODO: do we want this?
  end

  
  
  def show_current
    if session[:current_match_id] != nil  
      #re-serve the same old battle, because they haven't voted on it yet
      @battle = Battle.new(:match => Match.find(session[:current_match_id]))
    else
      flash[:notice] = "No previous battle could be found. Generating a new battle." #TODO: This should never happen for user. Get rid of this for production. 
      #we're ready to really make a new battle
      @battle = Battle.generate_new 
      session[:current_match_id] = @battle.match_id
    end
    render_battle
  end
  
  # GET /battles/new 
  def new
     #we always make a new battle in new!
     @battle = Battle.generate_new 
     session[:current_match_id] = @battle.match_id
    render_battle
  end

  # POST /battles
  # POST /battles.xml
  def create #TODO: code is kinda hacky. Better way to do this? Maybe with callbacks?
    puts "in create (is this working?)"
    winner_id = params[:winner_id]
    current_match_id = session[:current_match_id]
    if current_match_id == nil
      flash[:error] = "It looks like you tried to vote, but we had no history of sending you a battle to vote on. Try voting in this new battle."
      @previous_battle = nil
    else
      current_match = Match.find(session[:current_match_id]) #TODO: we need to resolve the issue of match creation timing for battles
      case winner_id.to_i #TODO: they could rig it so it's not an integer. Watch out.
        when current_match.opponent_1.id 
          @previous_battle = Battle.create(:winner => current_match.opponent_1, :loser => current_match.opponent_2)
          session[:previous_battle_id] = @previous_battle.id
        when current_match.opponent_2.id 
          @previous_battle = Battle.create(:winner => current_match.opponent_2, :loser => current_match.opponent_1)
          session[:previous_battle_id] = @previous_battle.id
        else
          flash[:error] = "It looks like you tried to vote for an animal that wasn't in the most recent battle we sent you. Try voting in this new battle."
          #TODO: what if they vote for an animal in an old battle which also participates in the new battle?
          @previous_battle = nil
      end
    end
    
    #clean up session so we know to serve a fresh one from 'new'
    #TODO: is this redundant or a good safeguard?
    session[:current_match_id] = nil
    session[:current_battle_id] = nil
    
    puts "end of create @@@@@@@?"
    
    
    respond_to do |format|
      format.html do
        @battle = Battle.generate_new
        session[:current_match_id] = @battle.match.id
        if request.xhr?
            render :partial => "battles/battle", :locals => {:battle => @battle, :previous_battle => @previous_battle}, :layout => false, :status => :created
          else 
            #redirect_to(:action => :new, :notice => 'Battle was successfully created.') 
            render :new, :locals => {:battle => @battle, :previous_battle => @previous_battle}
        end
      end
    end
  end

  # PUT /battles/1
  # PUT /battles/1.xml
  def update
    respond_to do |format|
      if @battle.update_attributes(params[:battle])
        format.html { redirect_to(@battle, :notice => 'Battle was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @battle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /battles/1
  # DELETE /battles/1.xml
  def destroy
    @battle.destroy

    respond_to do |format|
      format.html { redirect_to(battles_url) }
      format.xml  { head :ok }
    end
  end  
  
  protected
  
  def find_battle
    @battle = Battle.find(params[:id])
  end
  
  def render_battle #TODO: probably a better name for this
      begin
        previous_battle_id = session[:previous_battle_id]
        if previous_battle_id != nil
          @previous_battle = Battle.find(previous_battle_id)
        end

        #show a special message if it's the user's first time visiting.
        if ! cookies[:been_here_before]
          flash[:notice] = "Click the animal you think will win in the battle below!"
          cookies[:been_here_before] = true
        end

        respond_to do |format|
          format.html do
            if request.xhr?
              render :partial => "battles/battle", :locals => {:battle => @battle}, :layout => true, :status => :created
            else
              render "new"
            end
          end
        end


      rescue Animal::NotEnoughAnimalsLoadedException => e
        redirect_to(new_animal_path, :alert => "We need more animals in the database to create a battle. Add more animals.") #TODO: will need to change this once making new animals is behind password.
      end
  end
end
