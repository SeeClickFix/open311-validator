require 'test_helper';include TestHelper 


test "Services", :with => :services_resource do
  
  rule 'there should be at least one service right?' do 
    raw_services.each do |services| 
      services.response.size.should > 0
    end
  end
  
  rule 'all services should have a service code' do
    @session.services.each do |service|
      service.service_code.should_not be.nil?
    end
  end
  
end