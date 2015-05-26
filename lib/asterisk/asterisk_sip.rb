require 'asterisk/asterisk_constants'

module AsteriskSip
  include AsteriskConstants
  
  PEER_LIST_COMPLETE = "PeerlistComplete"
  
  def sip_peers
    # If there's no connection, or we're not logged in, bail
    return if !self.ready?
    
    # Send the command and read the response
    @logger.info "Running SIPPeers..."
    command = "Action: SIPPeers\r\n\n"
    response = self.send_request(command)
    
    # Check the response
    sippeers = []
    if (response[:response] == RESPONSE_SUCCESS)
      @logger.success("Success: Peer List Received")
      
      peer = read_response
      while peer[:event] != PEER_LIST_COMPLETE
        sippeers.push(peer)
        peer = read_response
      end
    else
      @logger.error("Failure: Unable to Retrieve Peer List")
    end
    
    @logger.info sippeers.inspect
    sippeers
  end
end