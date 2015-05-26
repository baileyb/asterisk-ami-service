require 'asterisk/asterisk'
require 'asterisk/asterisk_logger'

describe Asterisk do
  
  before (:each) do
    @host = "10.1.1.241"
    @port = "5038"
    @username = "admin"
    @secret = "stryker9"
    @asterisk = Asterisk.new @host, @port, @username, @secret
    @logger = AsteriskLogger.new
  end
  
  it "should initialize with server settings" do
    @logger.log_test "Initialize"
    @asterisk.host.should == @host
    @asterisk.port.should == @port
    @asterisk.username.should == @username
    @asterisk.secret.should == @secret
  end
  
  describe "Connection" do
    it "should connect succesfully with a valid host & port" do
      @logger.log_test "Connection - Valid"
      @asterisk.connect
      @asterisk.connected.should be_true
      @asterisk.disconnect if @asterisk.connected
      @asterisk.connected.should_not be_true
    end
    
    it "should not connect with a bad host" do
      @logger.log_test "Connection - Bad Host"
      @asterisk.host = "192.168.0.0"
      @asterisk.connect
      @asterisk.connected.should_not be_true
      @asterisk.disconnect if @asterisk.connected
      @asterisk.connected.should_not be_true
    end
    
    it "should not connect with a bad port number" do
      @logger.log_test "Connection - Bad Port"
      @asterisk.port = "1234"
      @asterisk.connect
      @asterisk.connected.should_not be_true
      @asterisk.disconnect if @asterisk.connected
      @asterisk.connected.should_not be_true
    end
  end

  describe "Authentication" do
    after (:each) do 
      @asterisk.logoff if @asterisk.logged_in
      @asterisk.logged_in.should_not be_true
      @asterisk.disconnect if @asterisk.connected
      @asterisk.connected.should_not be_true
    end
    
    it "should login successfully with a valid username & password" do
      @logger.log_test "Authentication - Valid"
      @asterisk.connect
      @asterisk.login
      @asterisk.logged_in.should be_true
      @asterisk.ready?.should be_true
    end

    it "should not login succesfully with a bad username" do
      @logger.log_test "Authentication - Bad Username"
      @asterisk.username = "bad_username"
      @asterisk.connect
      @asterisk.login
      @asterisk.logged_in.should_not be_true
      @asterisk.ready?.should_not be_true
    end

    it "should not login sucessfuly with a bad secret" do
      @logger.log_test "Authentication - Bad Secret"
      @asterisk.secret = "bad_secret"
      @asterisk.connect
      @asterisk.login
      @asterisk.logged_in.should_not be_true
      @asterisk.ready?.should_not be_true
    end
  end
  
  describe "Core" do
    before (:each) do
      @asterisk.connect
      @asterisk.login
      @asterisk.ready?.should be_true
    end
    
    after (:each) do 
      @asterisk.logoff if @asterisk.logged_in
      @asterisk.logged_in.should_not be_true
      @asterisk.disconnect if @asterisk.connected
      @asterisk.connected.should_not be_true
    end
    
    it "should run core show hints" do
      @logger.log_test "Core - Show Hints"
      @asterisk.show_hints
    end
  end
  
  describe "SIP" do
    before (:each) do
      @asterisk.connect
      @asterisk.login
      @asterisk.ready?.should be_true
    end
    
    after (:each) do 
      @asterisk.logoff if @asterisk.logged_in
      @asterisk.logged_in.should_not be_true
      @asterisk.disconnect if @asterisk.connected
      @asterisk.connected.should_not be_true
    end
    
    it "should run SIPPeers" do
      @logger.log_test "SIP - SIPPeers"
      @asterisk.sip_peers
    end
  end
end