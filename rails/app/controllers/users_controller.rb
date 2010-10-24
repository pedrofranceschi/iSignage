class UsersController < ApplicationController
  
  before_filter :check_authentication, :except => [:index, :authenticate]
  
  def index
  end
  
  def authenticate
    valid_user = User.find(:first, :conditions => ["username = ? and password = ?", params[:username], params[:password]])
    if valid_user != nil
      session[:username] = valid_user.username
      
      session[:current_mode] = "0"
      session[:current_text_color] = "255.0$!$255.0$!$255.0"
      session[:current_background_color] = "00.0$!$00.0$!$00.0"
      session[:current_text_alignment] = "1"
      session[:current_text] = "Hello world!"
      session[:current_font_size] = "72.0"
      session[:current_image_url] = ""
      
      redirect_to :action => "home"      
    else
      flash[:error] = "Wrong username/password."
      redirect_to :action => 'index'
    end
  end
  
  def logout
    reset_session
    redirect_to :action => "index"
  end
  
  def home
    @user = User.find_by_username(session[:username])
    @device_online = false
    @last_session = @user.sessions.last
    if @last_session != nil
      @device_online = (@user.sessions.last.active == true)
    end
    
    if @device_online && session[:current_mode] == "0"
      @last_session.commands.new(:name => "text_to_show", :value => session[:current_text]).save
      @last_session.commands.new(:name => "change_to_mode", :value => "1").save
      session[:current_mode] = "1"
    end
    
  end
  
  def change_text
    @session = Session.find(params[:session_id])
    @command = @session.commands.new(:name => "text_to_show", :value => params[:text])
    @command.save
    session[:current_text] = params[:text]
    
    redirect_to :action => "home"
  end
  
  def change_font_size
    @session = Session.find(params[:session_id])    
    @command = @session.commands.new(:name => "font_size", :value => params[:size])
    @command.save
    session[:current_font_size] = params[:size]
    
    redirect_to :action => "home"
  end
  
  def change_font_color
    @session = Session.find(params[:session_id])
    color_string = "#{params[:red]}$!$#{params[:green]}$!$#{params[:blue]}"
    @command = @session.commands.new(:name => "text_color", :value => color_string)
    @command.save
    session[:current_text_color] = color_string
    
    redirect_to :action => "home"
  end
  
  def change_background_color
    @session = Session.find(params[:session_id])
    color_string = "#{params[:red]}$!$#{params[:green]}$!$#{params[:blue]}"
    @command = @session.commands.new(:name => "background_color", :value => color_string)
    @command.save
    session[:current_background_color] = color_string
    
    redirect_to :action => "home"
  end
  
  def change_text_alignment
    @session = Session.find(params[:session_id])
    @command = @session.commands.new(:name => "text_alignment", :value => params[:text_alignment])
    @command.save
    session[:current_text_alignment] = params[:text_alignment]
    
    redirect_to :action => "home"
  end
  
  def change_image_url
    @session = Session.find(params[:session_id])
    
    if params[:url].blank?
      @session.commands.new(:name => "change_to_mode", :value => "1").save
      session[:current_mode] = "1"
    else
      @session.commands.new(:name => "change_to_mode", :value => "3").save
      session[:current_mode] = "3"
      @command = @session.commands.new(:name => "image_path", :value => params[:url])
      @command.save
    end
    
    session[:current_image_url] = params[:url]
    
    redirect_to :action => "home"
  end
  
  private

  def check_authentication
    unless session[:username]
      redirect_to :action => "index"
    end
  end
  
end
