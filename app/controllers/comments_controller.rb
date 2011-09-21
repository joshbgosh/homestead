class CommentsController < ApplicationController
  before_filter :find_comment, :only => [:vote_for, :vote_against, :undo_vote]
  before_filter :authenticate_user!, :only => [:vote_for, :vote_against, :undo_vote]

  #TODO: need to add the standard stuff here

  #TODO: make sure someone can't do crazy shit like vote for every comment on the site with a script
  
  #TODO: probably shouldn't have to have these 'unique' things. Other non-unique methods still exposed unfortunately.

  #TODO: maybe these should be on the user?
  
  def vote_for
    current_user.unique_vote_for(@comment)
    render :nothing => true
  end

  def vote_against
    current_user.unique_vote_against(@comment)
    render :nothing => true
  end

  def undo_vote
    current_user.unique_undo_vote_on(@comment)
    render :nothing => true
  end

  protected

  def find_comment
    @comment = Comment.find(params[:id])
  end



end
