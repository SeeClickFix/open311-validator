require 'test_helper';include TestHelper  

test "Service Discovery", :with => :discovery_url do
  
  rule 'url should end with "discovery"' do 
    resource.options[:discovery_url][-9..-1].should == 'discovery'
  end
  
  rule 'both formats should return results' do 
     resource.raw.xml.to_s.strip.should_not == '' && resource.raw.json.to_s.strip.should_not == ''
  end  
  
  rule 'both formats should have contacts' do 
     xml_discovery.contact.to_s.strip.should_not == ''
     json_discovery.contact.to_s.strip.should_not == ''
  end
  
  rule 'both formats should have key_service information' do 
     xml_discovery.key_service.to_s.strip.should_not == ''
     json_discovery.key_service.to_s.strip.should_not == ''
  end
  
  rule 'return valid DateTime objects' do 
    validate_date_time(xml_discovery.changeset).class.should == Time
    validate_date_time(json_discovery.changeset).class.should == Time
  end
    
  rule "contacts should return same for both formats" do 
    xml_discovery.contacts.should == json_discovery.contacts
  end
  
  rule "xml endpoint should be an array" do
    xml_endpoints.class.should == Array
  end
  
  rule "there should be at least one endpoint" do
    xml_endpoints.size.should > 0
  end
  
  rule "each endpoint should have a specification" do 
    all_endpoints.each do |endpoint|
      endpoint.specification.should_not == ''
    end
  end
  
  rule "each endpoint should have a url" do 
    all_endpoints.each do |endpoint|
      endpoint.url.should_not == ''
    end
  end
  
  rule "each endpoint should have a changeset" do 
    all_endpoints.each do |endpoint|
      endpoint.changeset.should_not == ''
    end
  end
  
  rule "each endpoint should have a valid changeset" do 
    all_endpoints.each do |endpoint|
      validate_date_time(endpoint.changeset).class.should == Time
    end
  end
  
  rule "each endpoint should have a changeset in the past" do 
    all_endpoints.each do |endpoint|
      validate_date_time(endpoint.changeset).should < Time.now
    end
  end
  
  rule "each endpoint should have a type" do 
    all_endpoints.each do |endpoint|
      endpoint.marshal_dump[:type].should_not == ''
    end
  end
  
  rule "each endpoint should have an array of formats" do 
    xml_endpoints.each do |endpoint|
      endpoint.formats.format.class.should == Array
    end
    json_endpoints.each do |endpoint|
      endpoint.formats.class.should == Array
    end
  end
  
  rule "each endpoint should have at least one supported format" do 
    all_endpoints.each do |endpoint|
      Session.endpoint_formats(endpoint).size.should > 0
    end
  end
  
  rule "all v2 endpoints should support xml" do
    v2_endpoints.each do |endpoint|
      Session.endpoint_formats(endpoint).select{|format| format == 'text/xml' }.size.should > 0
    end
  end
  
end








