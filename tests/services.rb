
  #  @session.resources  = History of resources for entire session of tests.
  #  @resource = currently tested resource.
  #  @resource.options  = options used for that resource
  #  @resource.json.response = objectified response
  #  @resource.json.headers = response headers
  #  @resource.json.body = response body
  #  @resource.json.request = httparty request object
  #
  #

test "Services", :with => :services_resource do
  
  rule 'each should return something' do 
    @resource.xml.each do |request|
      request.response.should_not == ''
    end
    
    if @resource.options.json
      @resource.json.each do |request|
        request.response.should_not == ''
      end
    end
  end
  
end