

class BattlesController < ApplicationController
  # GET /battles
  # GET /battles.xml
  respond_to :html, :xml, :json
  
  before_filter :find_battle, :only => [:show, :update, :destroy]
  
  #TODO: Some battle stuff might be better to calculate through matches (and cache in matches)
  
  def index
    @battles = Battle.all
  end

  # GET /battles/1
  def show
  end

  # GET /battles/new
  # GET /battles/new.xml
   
  def new
    begin
      @battle = Battle.generate_new
      session[:current_battle] = @battle
        
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
      
    rescue Animal::NotEnoughAnimalsLoadedException => e
      redirect_to(new_animal_path, :alert => "We need more animals in the database to create a battle. Add more animals.") #TODO: will need to change this once making new animals is behind password.
    end
  end

  # POST /battles
  # POST /battles.xml
  def create #TODO: code is kinda hacky. Better way to do this? Maybe with callbacks?
    battle_params = params[:battle]
    
    #if battle_params[:battle_id] && battle_params[:battle_id] != "" #TODO: watch out for SQL injection here.
    #  @previous_battle = Battle.find(battle_params[:battle_id]) #TODO: this probably isn't a hot idea. Is there a problem if users forge this?
    #end
    
    @previous_battle = Battle.create(battle_params)
    
    respond_to do |format|
      if @previous_battle.save
        format.html do
         @battle = Battle.generate_new
          if request.xhr?
            render :partial => "battles/battle", :locals => {:battle => @battle, :previous_battle => @previous_battle}, :layout => false, :status => :created
          else 
           #redirect_to(:action => :new, :notice => 'Battle was successfully created.') 
            render :new, :locals => {:battle => @battle, :previous_battle => @previous_battle}
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
end
