
module DiscoveryHelper
  
  def xml_endpoints
    @resource.xml.response.discovery.endpoints.endpoint
  end
  
  def json_endpoints
    @resource.json.response.endpoints
  end
  
  def all_endpoints
    xml_endpoints + json_endpoints
  end
  
  def xml_discovery
    @resource.xml.response.discovery
  end
  
  def json_discovery
    @resource.json.response
  end
  
  extend self
end