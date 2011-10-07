require 'test_helper';include TestHelper 

test "Service Definitions", :with => :definition_resource do
  
  # rule 'each should return something' do 
  #   @resource.xml.each do |request|
  #     request.response.should_not == ''
  #   end
  #   
  #   if @resource.options.json
  #     @resource.json.each do |request|
  #       request.response.should_not == ''
  #     end
  #   end
  # end
  
  rule 'test resource' do
    raise @session.resource.raw.inspect
    # raise @session.prev_resource.inspect
    # raise @resource.xml.inspect
  end
  
end