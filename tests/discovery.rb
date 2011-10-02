
  #  @session.resources  = History of resources for entire session of tests.
  #  @resource = currently tested resource.
  #  @resource.options  = options used for that resource
  #  @resource.json.response = objectified response
  #  @resource.json.headers = response headers
  #  @resource.json.body = response body
  #  @resource.json.request = httparty request object
  #
  #

test "Service Discovery", :with => :discovery_resource do
  
  rule 'url should end with "discovery"' do 
    @resource.options.discovery_url[-9..-1].should == 'discovery'
  end
  
  rule 'both formats should return results' do 
     @resource.xml.should_not == '' && @resource.json.should_not == ''
  end  
  
  rule 'return valid DateTime objects' do 
    validate_date_time(@resource.xml.response.discovery.changeset).should == true
    validate_date_time(@resource.json.response.changeset).should == true
  end
    
  rule "contacts should return same for both formats" do 
    @resource.xml.response.discovery.contacts.should == @resource.json.response.contacts
  end
  
  rule "xml endpoint should be an array" do
    @resource.xml.response.discovery.endpoints.endpoint.class.should == Array
  end
  
  rule "there should be at least one endpoint" do
    @resource.xml.response.discovery.endpoints.endpoint.size.should > 0
  end
  
end