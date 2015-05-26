xml.instruct!
xml.extensions do
  @extensions.each do |e|
    xml.extension do
      xml.name e[:name]
      xml.sip_url e[:sip_url]
      xml.state e[:state]
      xml.watchers e[:watchers]
    end
  end
end