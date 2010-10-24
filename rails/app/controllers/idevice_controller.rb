class IdeviceController < ApplicationController
  
  before_filter :check_user_agent
  
  def status
    render :text => "OK", :status => 200
  end
  
  def login
    @user = User.find(:first, :conditions => ["username = ? AND password = ?", params[:username], params[:password]])
    if @user
      render :text => "OK$__$username:#{@user.username}|full_name:#{@user.full_name}|user_id:#{@user.id}|mode:0", :code => 200
    else
      render :text => "INVALID_DATA", :code => 401
    end
  end
  
  def start_session
    @user = User.find(params[:user_id])
    @last_session = @user.sessions.last
    if @last_session != nil
      @last_session.active = false
      @last_session.save
    end
    
    @session = @user.sessions.new(:active => true)
    @session.save
    if @user && @session
      render :text => "OK$__$session:#{@session.id}", :code => 200
    else
      render :text => "INVALID_DATA", :code => 401
    end
  end
  
  def end_session
    @session = Session.find(params[:session_id])
    @session.active = false
    @session.save
    
    render :nothing => true
  end
  
  def session_commands
    @session = Session.find(params[:session_id])
    if @session == nil
      render :text => "INVALID_DATA"
    end
    
    output_string = "OK$__$"
    Command.find(:all, :conditions => ["session_id = ? AND executed = ?", @session.id, false]).each do |command|
      output_string << "name$:$#{command.name}$/$value$:$#{command.value}$|$"
      
      command.executed = true
      command.save
    end
    render :text => output_string
  end
  
  def create_account
     if User.find_by_username(params[:username])
       render :text => "UNAVAILABLE_USERNAME"
     else
       if params[:username].blank? || params[:password].blank? || params[:email].blank? || params[:full_name].blank?
         render :text => "BLANK_FIELDS"
       else
         @user = User.new(:username => params[:username], :password => params[:password], :email => params[:email], :full_name => params[:full_name])
         if @user.save
           render :text => "OK"
         else
           render :text => "ERROR"
         end
       end
     end
  end
  
  private
  
  def check_user_agent
    if request.user_agent != "CFNetwork"
      render :text => "ERROR", :status => 401
    end
  end
  
end
