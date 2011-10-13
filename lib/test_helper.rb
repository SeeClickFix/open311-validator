
module TestHelper

  def validate_date_time(time)
    time.is_a?(Time) ? time : Time.iso8601(time) rescue false
  end
  
  def resource
    @session.resource
  end
  
  def xml_endpoints
    @session.discovery.raw.xml.response.discovery.endpoints.endpoint
  end
  
  def json_endpoints
    @session.discovery.raw.json.response.endpoints
  end
  
  def all_endpoints
    xml_endpoints + json_endpoints
  end
  
  def v2_endpoints
    all_endpoints.select{|endpoint| endpoint.specification =~ /^.*_v2$/i }
  end
  
  def xml_discovery
    @session.discovery.raw.xml.response.discovery
  end
  
  def json_discovery
    @session.discovery.raw.json.response
  end

  extend self
end