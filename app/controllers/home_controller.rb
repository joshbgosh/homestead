class HomeController < ApplicationController
  
  respond_to :html
  
  def index
  end
  
  def magic
    respond_with do |format|
      format.html do
        if request.xhr?
          render :partial => "home/magic", :layout => false, :status => :created
        end
      end
    end
  end

end
