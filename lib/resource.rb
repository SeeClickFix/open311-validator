

class Resource
  
  def initialize(session,options)
    @options = options
    @raw = OpenStruct.new
    @session = session
    @last_resource = session.resource
  end
  
  def get
    self.send @options.with
  end
  
  def discovery_resource
    @raw.json = Response.new.get("#{@options.discovery_url}.json") if @options.json
    @raw.xml  = Response.new.get("#{@options.discovery_url}.xml")
    @raw.options = @options
    @raw
  end
  
  def services_resource
    @raw.json = []
    @raw.xml  = []
    
    # For each endpoint...
    @session.discovery.xml.response.discovery.endpoints.endpoint.each do |endpoint|
      next if type(endpoint) == 'production' and !@options.production
      @raw.xml << Response.new.get("#{endpoint.url}/services.xml?jurisdiction_id=#{@options.jurisdiction_id}")
    end
    
    @session.discovery.json.response.endpoints.each do |endpoint|
      next if type(endpoint) == 'production' and !@options.production
      @raw.json << Response.new.get("#{endpoint.url}/services.xml?jurisdiction_id=#{@options.jurisdiction_id}")
    end if @options.json
    
    @raw.options = @options
    @raw
  end
  
  def definition_resource
    @raw.json = []
    @raw.xml  = []
    # For each endpoint...
    @session.discovery.xml.response.discovery.endpoints.endpoint.each do |endpoint|
      next if type(endpoint) == 'production' and !@options.production
      @last_resource.xml.each do |service_list|
        service_list.response.services.each do |service|
          next unless service.metadata
          @raw.xml << Response.new.get("#{endpoint.url}/services/#{service.service_code}.xml?jurisdiction_id=#{@options.jurisdiction_id}")
        end
      end
    end
    
    @session.discovery.json.response.endpoints.each do |endpoint|
      next if type(endpoint) == 'production' and !@options.production
      @last_resource.json.each do |service_list|
        service_list.response.services.each do |service|
          next unless service.metadata
          @raw.json << Response.new.get("#{endpoint.url}/services/#{service.service_code}.xml?jurisdiction_id=#{@options.jurisdiction_id}")
        end
      end
    end if @options.json
  
    @raw.options = @options
    @raw
  end
  
  # 
  # Purpose: Create service requests
  # URL: https://[API endpoint]/requests.[format]
  # Sample URL: https://api.city.gov/dev/v2/requests.xml
  # Format sent: Content-Type: application/x-www-form-urlencoded
  # Formats returned: XML (JSON available if denoted by Service Discovery)
  # HTTP Method: POST
  # Requires API Key: Yes
  #
  #
  # Required Arguments
  # jurisdiction_id
  # service_code (obtained from GET Service List method)
  # location: either lat & long or address_string or address_id must be submitted
  # attribute - only required if the service_code requires a service definition with required fields
  # Explanation: An array of key/value responses based on Service Definitions. This takes the form of attribute[code]=value where multiple code/value pairs can be specified as well as multiple values for the same code in the case of a multivaluelist datatype (attribute[code1][]=value1&attribute[code1][]=value2&attribute[code1][]=value3) - see example
  # 
  def create_resource_once
    @raw.xml  = []
    @raw.json = []
    # For each endpoint...
    @session.discovery.xml.response.discovery.endpoints.endpoint.each do |endpoint|
      next if type(endpoint) == 'production' and !@options.production
      @raw.xml << Response.new.post("#{endpoint.url}/requests.xml",data_from_options)
    end
    
    @session.discovery.json.response.endpoints.each do |endpoint|
      next if type(endpoint) == 'production' and !@options.production
      @raw.json << Response.new.post("#{endpoint.url}/requests.json",data_from_options)
    end if @options.json
    
    @raw.options = @options
    @raw
  end
  
  def data_from_options
    ## Converting @options back to a hash and merge them with user-supplied
    #  post data.
    { :api_key => @options.api_key,
      :jurisdiction_id => @options.jurisdiction_id,
      :service_code => first_service_code,
      :address_string => @options.address
    }.merge!(@options.post)
  end
  
  def first_service_code
    @session.resources[1].xml.first.response.services.service.service_code
  end
  
  def type(endpoint)
    endpoint.marshal_dump[:type]
  end
  
end