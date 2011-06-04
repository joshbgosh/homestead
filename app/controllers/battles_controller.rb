class BattlesController < ApplicationController
  # GET /battles
  # GET /battles.xml
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
   
  def new
    @battle = Battle.new
    @opponent_1, @opponent_2 = pick_opponents
      
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @battle }
      end
  end
  
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
  
  def new_random
    @battle = Battle.new
    
	  @battle_type = :new
	  
	  @opponent_1, @opponent_2 = self.make_random_match
	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @battle }
    end
  end
  
  def new_smart
    @battle = Battle.new
    
    @battle_type = :new_smart
    
	  @opponent_1, @opponent_2 = self.make_close_match
	
    respond_to do |format|
      format.html # new_smart.html.erb
      format.xml  { render :xml => @battle }
    end
  end
  
  def new_close_match
    @battle = Battle.new
    
    @battle_type = :new_close_match #doing it like this seems hackable TODO: change
    
    @opponent_1, @opponent_2 = self.make_close_match
    
    respond_to do |format|
      format.html # new_close_match.html.erb
      format.xml  { render :xml => @battle }
    end
  end

  # GET /battles/1/edit
  def edit
    @battle = Battle.find(params[:id])
  end

  # POST /battles
  # POST /battles.xml
  def create
    #TODO: remove this hack
    battle_type = params[:battle][:battle_type]
    @battle = Battle.new(params[:battle].delete(:battle_type))

    respond_to do |format|
      if @battle.save
        #if battle_type.eql?("new") or battle_type.eql?("new_smart") or battle_type.eql?("new_close_match")
        #   redirect_action = battle_type
        #else
        #    redirect_action = :new
        #end
        format.html { redirect_to(:action => :new, :notice => 'Battle was successfully created.') }
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
