xml.instruct!
xml.peers do
  @peers.each do |p|
    xml.peer do
      xml.event p[:event]
      xml.channeltype p[:channeltype]
      xml.objectname p[:objectname]
      xml.chanobjecttype p[:chanobjecttype]
      xml.ipaddress p[:ipaddress]
      xml.ipport p[:ipport]
      xml.dynamic p[:dynamic]
      xml.forcerport p[:forcerport]
      xml.videosupport p[:videosupport]
      xml.textsupport p[:textsupport]
      xml.acl p[:acl]
      xml.status p[:status]
      xml.realtimedevice p[:realtimedevice]
    end
  end
end