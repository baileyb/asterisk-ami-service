require 'asterisk/asterisk_constants'

module AsteriskConnection  
  include AsteriskConstants
  
  ## Convience method to connect and login in one call
  ## After you call this method, call ready? to ensure 
  ## the server is ready to accept requests
  def start
    self.connect
    self.login if @connected
  end
  
  ## Connect to the Asterisk Management Interface (AMI) server
  ## Results:
  ## => Success   @socket open, @connected = true
  ## => Failure   @socket nil,  @connected = false
  def connect
    @logger.request "Connecting to Asterisk Manager (" + @host + ":" + @port + ")"

    begin
      # Try to open a socket
      @socket = TCPSocket.new @host, @port

      # Parse the initial connection message.  This message is sent right after a socket connection is established, and consists 
      # of one line of the format: Asterisk Call Manager/1.1  
      @connected = (@socket.gets.gsub("\r\n", "") == RESPONSE_CONNECTION)
      @logger.response("Success: Connection Established") if @connected
      @logger.fatal("Error: Connection response did not match expected: " + RESPONSE_CONNECTION) if !@connected
    rescue Exception => e
      @logger.fatal "Error: Connection error occurred: " + e.message
      @connected = false
    end
  end
  
  ## Disconnect the socket and reset the connection flags
  ## Results:
  ## => Success   @socket closed, @connected = false, @logged_in = false
  def disconnect 
    # If the socket's open, close it  
    @logger.info "Disconnecting from Asterisk Manager...Goodbye!" 
    @socket.close if !@socket.nil?
    
    # Reset flags
    @connected = false
    @logged_in = false
  end
  
  ## Logout of the Asterisk Manager Interface (AMI)
  ## Message format:
  ## => Action: Logout\r\n
  ## => Username: @username\r\n
  ## => Secret: @secret\r\n\n
  ##
  ## Results:
  ## => Success   @logged_in = true
  ## => Failure   @logged_in = false
  def login
    # If there's no connection, bail
    return if !@connected

    # Set the logged_in flag to false
    @logged_in = false
    
    # Send the command and read the response
    command = "Action: Login\r\nUsername: " + @username + "\r\nSecret: " + @secret + "\r\n\n"
    response = self.send_request(command)
        
    # Check the response, set the flag, and write the log message
    @logged_in = self.check_response_status(response)
    
    if @logged_in
      @logger.success("Success: " + response[:message])
      
      # The AMI immediately sends an event message after login.  We don't care
      # about it, but it gets in the way of sending other commands.  Read it and throw it in the log file
      self.read_response
      
      # Turn events off so we don't have to handle a bunch of asynchronous messages
      command = "Action: Events\r\nEventmask: Off\r\n\n"
      response = self.send_request(command)
      
      @logger.success("Success: Async events turned off") if (response[:response] == RESPONSE_SUCCESS)
      @logger.error("Failure: Could not turn async events off.  This may cause problems") if (response[:response] != RESPONSE_SUCCESS)
    else
      @logger.fatal("Error: " + response[:message])
    end
  end
  
  ## Logoff of the Asterisk Manager Interface (AMI)
  ## Message format:
  ## => Action: Logoff\r\n\n
  ##
  ## Results:
  ## => Success   @logged_in = false
  ## => Failure   @logged_in = true
  def logoff
    # If there's no connection, bail
    return if !@connected

    # Send the command and read the response
    command = "Action: Logoff\r\n\n"
    response = self.send_request(command)
    
    # Check the response, set the flag, and write the log message
    @logged_in = (response[:response] == RESPONSE_GOODBYE)
    @logger.success("Success: " + response[:message]) if !@logged_in
    @logger.error("Failure: " + response[:message]) if @logged_in
  end
      
  ## Return true if the connection is active and we're logged in
  ## otherwise, return false
  def ready?
    @connected && @logged_in
  end
end