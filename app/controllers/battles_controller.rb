class BattlesController < ApplicationController
  # GET /battles
  # GET /battles.xml
  respond_to :html, :xml, :json
  
  #TODO: Some battle stuff might be better to calculate through matches (and cache in matches)
  
  def index
    @battles = Battle.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @battles }
    end
  end

  # GET /battles/1
  # GET /battles/1.xml
  def show
    @battle = Battle.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @battle }
    end
  end

  # GET /battles/new
  # GET /battles/new.xml
   
  def new #TODO: needs to do something better when there's no animals in DB (error with finding opponent)
    @battle = new_battle_helper
        
      respond_to do |format|
        format.html do
          if request.xhr?
            render :partial => "battles/battle", :locals => {:battle => @battle}, :layout => true, :status => :created
          else
            format.html # new.html.erb
          end
        end
        format.xml  { render :xml => @battle }
      end
  end

  # POST /battles
  # POST /battles.xml
  def create #TODO: code is kinda hacky. Better way to do this? Maybe with callbacks?
    battle_params = params[:battle]
    
    #might want to put match creation back here again @match = Match.get_or_create_with(Animal.find(battle_params[:winner_id]), Animal.find(battle_params[:loser_id]))#
    @battle = Battle.create(battle_params)
    
    respond_to do |format|
      if @battle.save
        format.html do
          if request.xhr?
            @battle = new_battle_helper
            render :partial => "battles/battle", :locals => {:battle => @battle}, :layout => false, :status => :created
          else 
           redirect_to(:action => :new, :notice => 'Battle was successfully created.') 
          end
        end 
        format.xml  { render :xml => @battle, :status => :created, :location => @battle }
      else
        format.html { render :action => :new}
        format.xml  { render :xml => @battle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /battles/1
  # PUT /battles/1.xml
  def update
    @battle = Battle.find(params[:id])

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
    @battle = Battle.find(params[:id])
    @battle.destroy

    respond_to do |format|
      format.html { redirect_to(battles_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
    #TODO: why can't I call these with self or just plain?
  def pick_opponents
    n = rand(100)
    
    if n < 40
      BattlesController.make_random_close_match
    elsif n < 50
      BattlesController.make_new_close_match
    elsif n < 90
      BattlesController.make_random_match
    else
      BattlesController.make_new_random_match
    end
  end
  
  def new_battle_helper
    battle = Battle.new
    opponent_1, opponent_2 = pick_opponents
    match = Match.get_or_create_with(opponent_1, opponent_2)
    battle.match_id = match.id
    match.save
    battle
  end
  
  def self.make_random_match
    opponent_1 = Animal.random
    opponent_2 = opponent_1.random_opponent
    return opponent_1, opponent_2
  end
  
  def self.make_new_random_match
    opponent_1 = Animal.by_fewest_battles.first
    opponent_2 = opponent_1.random_opponent
    if rand(1) == 1
      tmp = opponent_1
      opponent_1 = opponent_2
      opponent_2 = tmp
    end
    return opponent_1, opponent_2
  end
    
  def self.make_new_close_match
    opponent_1 = Animal.by_fewest_battles.first
    opponent_2 = opponent_1.closely_matched_opponent
    if rand(1) == 1
      tmp = opponent_1
      opponent_1 = opponent_2
      opponent_2 = tmp
    end
    return opponent_1, opponent_2
  end
  
  def self.make_random_close_match
    opponent_1 = Animal.random
    opponent_2 = opponent_1.closely_matched_opponent
    if rand(1) == 1
      tmp = opponent_1
      opponent_1 = opponent_2
      opponent_2 = tmp
    end
    return opponent_1, opponent_2
  end
end
