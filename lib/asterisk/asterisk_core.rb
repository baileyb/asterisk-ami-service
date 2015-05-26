require 'asterisk/asterisk_constants'

module AsteriskCore
  include AsteriskConstants
    
  def show_hints
    # Send the command & read the response
    send_command("core show hints")
    response,payload = read_cli_response
    
    # Log the response
    @logger.response response.inspect
    @logger.error ("Failure: " + response["Message"]) if (response["Response"] == RESPONSE_FAILURE)
    @logger.success ("Success: Payload Received") if (response["Response"] == RESPONSE_FOLLOWS)
    
    # Parse the payload if it's available
    return if payload.empty?
    
    # Split the payload into an array
    lines = payload.split("\n")
        
    # Throw the first two lines away, the first is blank, and the second is a title
    # Also throw away the last two lines.  One is just a footer message, and the other is a end of table
    lines = lines[2..-3]
    
    # Go through the lines, each line is one extension
    extensions = []
    lines.each do |l|
      values = l.split(" ")
      extension = {}
      extension[:name] = values[0].split("@")[0]
      extension[:sip_url] = values[2]
      extension[:state] = values[3].split(":")[1]
      extension[:watchers] = values[5]
      extensions.push(extension)
    end
    
    @logger.info extensions.inspect
    extensions
  end
  
  def send_command(command)
    @logger.info "Running CLI command: " + command
    message = CMD_MESSAGE + command + CMD_MESSAGE_END
    
    @logger.request message
    @socket.puts message
  end
  
  def read_cli_response
    # Setup our return values
    response = {}
    payload = String.new

    # Read the first two lines - they represent the normal response hash
    2.times do    
      line = @socket.gets
      k,v = line.split(": ")
      response[k] = v.gsub("\r\n", "")
    end
    
    # Read the next line, if it contains "No such command" - bail, otherwise keep parsing
    line = @socket.gets    
    if (line.include? "No such command")
      response["Response"] = "Failure"
      response["Message"] = "Bad Command"
      
      # Flush the end message line
      @socket.gets
    else
      # This line is the first line of the payload, keep parsing
      payload = line
      
      # Read the rest of the payload and concat
      line = @socket.gets
      while line != RESPONSE_MESSAGE_END
        payload += line
        line = @socket.gets
      end
    end
          
    # Read one more line to throw away the last "\r\n" and flush the buffer
    @socket.gets
    
    # Return the response & payload
    return response,payload
  end
end