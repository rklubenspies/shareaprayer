# The PrayersController handles all forward-facing prayer request related pages and methods on the site.
# 
# @since 0.1.0
# @author Robert Klubenspies
class PrayersController < ApplicationController
  # Displays homepage with three tabs: Prayer Requests, Submit a Prayer Request, About Share a Prayer
  # 
  # @since 0.1.0
  # @author Robert Klubenspies
  def index
    # Determine when the oldest prayer's timestamp from params[:last] OR use the current time + 1 second
    last = params[:last].blank? ? Time.now.utc + 1.second : Time.parse(params[:last])
    
    # Retrieve 10 prayer requests based on the timestamp
    @prayers = Prayer.feed(last)

    # Respond to multiple request types
    respond_to do |format|
      format.js   # Respond with UJS to dynamically add to list on homepage (app/views/prayers/index.js.erb)
      format.html # Respond with HTML view (app/views/prayers/index.html.haml)
    end
  end
  
  # Creates new prayer requests through a Rails remote form (UJS) post. Renders UJS response located in app/views/prayers/create.js.erb
  # 
  # @since 0.1.0
  # @author Robert Klubenspies
  def create
    # Find or create Email entry for email address on form and assign it to instance variable @email
    @email = Email.find_or_create_by(email: params[:prayer][:email])
    
    # Remove email address from form parameters (for saftey reasons - don't want the email address showing up elseware)
    params[:prayer].delete :email
    
    # Assign checkbox "Would you like to receive a link to..." value to @email_me instance variable
    @email_me = params[:prayer][:email_me]
    
    # Remove checkbox value from form parameters (for saftey reasons - don't want user's decision showing up elseware)
    params[:prayer].delete :email_me
    
    # Create form parameter for User's IP Address
    params[:prayer][:ip_address] = request.env['REMOTE_ADDR']
    
    # Ensure location data is correct
    if params[:prayer][:location] != "Anonymous"
      l = Geocoder.search(params[:prayer][:location])
      params[:prayer][:location] = l[0].address
    elsif params[:prayer][:location] == "Anonymous"
      params[:prayer][:location] = nil
    end
    
    # Intialize Prayer object and "build" it under Email object persisted in @email instance variable
    @prayer = @email.prayers.build(params[:prayer])
    
    # Save Prayer object
    if @prayer.save
      # If user chose to have link emailed to them, email it
      if @email_me == "1"
        PrayerMailer.permalink_email(@prayer).deliver     # Email user permalink
      # User doesn't want to have link emailed to them
      else
        puts "User chose not to have permalink emailed."  # Log that user did not want to receive email permalink
      end
    end
  end
  
  # Displays a single prayer request's permalinked page based on its id (found in params[:id] and passed by the route)
  # 
  # @since 0.1.0
  # @author Robert Klubenspies
  # @see ApplicationHelper#already_prayed_for? Evaluations run in @already_prayed_for and @already_reported are similar to ApplicationHelper#already_prayed_for?
  def show
    # Retrieve prayer request by params[:id]
    @prayer = Prayer.find(params[:id])
    
    # Determine whether or not the prayer request was already prayed for
    @already_prayed_for = (session[:prayed_for] ||= []).include? params[:id]
    
    # Determine whether or not the prayer request was already reported
    @already_reported = (session[:reported] ||= []).include? params[:id]
  end
  
  # Proccesses a prayer being prayed for
  # 
  # @since 0.1.0
  # @author Robert Klubenspies
  def prayed_for
    # Determine whether or not the prayer request was already prayed for
    if (session[:prayed_for] ||= []).include? params[:id]
      return false
    # Prayer request was not already prayed for, proceed as usual
    else
      # Find Prayer by params[:id]
      @prayer = Prayer.find(params[:id])
    
      # Increment :time_prayed_for count in database row
      @prayer.inc(:times_prayed_for, 1)
    
      # Check to make sure updates were saved
      if @prayer.save
        (session[:prayed_for] ||= []) << params[:id]  # Add string representation of prayer's id to session array of prayer requests that were prayed for (for making sure user doesn't press button again by accident)
      end
    
      # Respond to one request type
      respond_to do |format|
        format.js   # Respond with UJS to manipulate DOM (app/views/prayers/prayed_for.js.erb)
      end
    end
  end
  
  # Proccesses a prayer being reported
  # 
  # @since 0.1.0
  # @author Robert Klubenspies
  def report
    # Determine whether or not the prayer request was already reported
    if (session[:reported] ||= []).include? params[:id]
      return false
    # Prayer request was not already reported for, proceed as usual
    else
      # Find Prayer by params[:id]
      @prayer = Prayer.find(params[:id])
    
      # If prayer request was already reported 2 or more times, then destroy the prayer request
      if @prayer.reported >= 2
        @prayer.destroy
      # Prayer request need to be reported more times before being destroyed, increment reported count
      else
        # Increment :reported count in database row
        @prayer.inc(:reported, 1)
      
        # Check to make sure updates were saved
        if @prayer.save
          (session[:reported] ||= []) << params[:id]  # Add string representation of prayer's id to session array of prayer requests that were reported (for making sure user doesn't press button again by accident)
        end
      end
    
      # Respond to one request type
      respond_to do |format|
        format.js   # Respond with UJS to manipulate DOM (app/views/prayers/report.js.erb)
      end
    end
  end
end