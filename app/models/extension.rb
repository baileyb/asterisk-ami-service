require 'asterisk/asterisk'

class Extension < ActiveRecord::Base
  def self.status 
    a = connect_asterisk
    extensions = []
    extensions = a.show_hints if a.ready?
    disconnect_asterisk(a)
    extensions
  end
  
  def self.peers
    a = connect_asterisk
    peers = []
    peers = a.sip_peers if a.ready?
    disconnect_asterisk(a)
    peers
  end
  
  def self.connect_asterisk
    asterisk = Asterisk.new("10.1.1.241", "5038", "admin", "stryker9")
    asterisk.connect
    asterisk.login
    asterisk
  end
  
  def self.disconnect_asterisk(asterisk)
    asterisk.logoff
    asterisk.disconnect
  end
end
