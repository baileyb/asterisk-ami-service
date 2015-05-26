module AsteriskConstants
  # Initial connection response
  RESPONSE_CONNECTION = "Asterisk Call Manager/1.1"
  
  ## Success/Failure codes returned from the Asterisk Manager Interface
  RESPONSE_SUCCESS = "Success"
  RESPONSE_FAILURE = "Failure"
  RESPONSE_FOLLOWS = "Follows"
  RESPONSE_GOODBYE = "Goodbye\r\n"
  
  # CLI command message format
  CMD_MESSAGE = "Action: Command\r\nCommand: "
  CMD_MESSAGE_END = "\r\n\n"
  RESPONSE_MESSAGE_END = "--END COMMAND--\r\n"
end
  