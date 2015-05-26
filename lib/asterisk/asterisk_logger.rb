class AsteriskLogger
  @@logfile = "log/asterisk.log"
  
  def request(message)
    self.log "REQUEST ", message.gsub("\r\n", " ").gsub(" \n", "")
  end
  
  def response(message)
    self.log "RESPONSE", message
  end
  
  def event(message)
    self.log "EVENT", message
  end
  
  def info(message)    
    self.log "INFO    ", message
  end
  
  def success(message)    
    self.log "SUCCESS ", message
  end
  
  def error(message)
    self.log "ERROR   ", message
  end
  
  def fatal(message)
    self.log "FATAL   ", message
  end

  def log(title, message)
    l = File.new(@@logfile, 'a')
    l.puts Time.now.inspect + ": " + title + "\t" + message + "\n"
    l.close
  end
  
  def clear
    File.open(@@logfile, 'w') { |file| file.truncate(0) }
  end
  
  def log_test(test_name)
    l = File.new(@@logfile, 'a')
    l.puts "\n>>>>>>>>>>>>> rspec: Test Started (" + test_name + ")\n"
    l.close
  end
end
