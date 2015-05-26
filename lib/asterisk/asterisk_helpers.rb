require 'asterisk/asterisk_constants'

module AsteriskHelpers
  include AsteriskConstants
  
  ## Send a new request and process the response
  ## Messages are returned in multiple lines seperated by "\r\n"
  ## For each line, the keys & values are seperated by ": "
  ## The return value from this method is a hash of key/value pairs
  def send_request(command)
    @logger.request command
    @socket.puts command 
    read_response
  end
  
  ## Read a response from the socket and build a hash.  This method
  ## also logs the has to the log file
  def read_response
    response = {}
    line = @socket.gets
    while line != "\r\n"
      k,v = line.split(": ")
      response[k.downcase.to_sym] = v.gsub("\r\n", "")
      line = @socket.gets
    end
    @logger.response response.inspect
    response
  end
  
  ## Check the response status. This method takes a hash created
  ## by send_request and checks the value of the "Response" key
  def check_response_status(response)
    (response[:response] == RESPONSE_SUCCESS)
  end
end