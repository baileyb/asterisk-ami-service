require 'socket'
require 'asterisk/asterisk_constants'
require 'asterisk/asterisk_helpers'
require 'asterisk/asterisk_logger'
require 'asterisk/asterisk_connection'
require 'asterisk/asterisk_core'
require 'asterisk/asterisk_sip'

class Asterisk    
  ## Include sub-modules
  include AsteriskConstants   # String constants for sending commands and parsing responses
  include AsteriskHelpers     # Methods for reading and parsing generic responses
  include AsteriskConnection  # Basic connection & authentication methods
  include AsteriskCore        # Commands corresponding to Asterisk CLI: core etc etc
  include AsteriskSip         # Commands corresponding to Asterisk CLI: sip etc etc
    
  ## Public get/setters
  attr_accessor :host, :port, :username, :secret
  attr_reader :connected, :logged_in
  
  ## Constructor - initializes the Asterisk class with connection and login details
  def initialize (host, port, username, secret)
    @host = host
    @port = port
    @username = username
    @secret = secret
    
    @connected = false
    @logged_in = false
    @logger = AsteriskLogger.new
  end
end