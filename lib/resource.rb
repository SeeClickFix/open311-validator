

class Resource
  attr_accessor :options, :raw
  
  def initialize(session,options)
    @options = options
    @session = session
    @last_resource = session.resource
  end
  
  def get_next
    self.send @options[:with]
  end
  
  def discovery_url
    @raw = OpenStruct.new
    @raw.json = Client.new(@options[:discovery_url],'json').get(".json")
    @raw.xml  = Client.new(@options[:discovery_url],'xml').get(".xml")
  end

  def services_resource
    @raw = []
    @session.endpoint_array.each do |endpoint|
      response = Client.new(endpoint[0],endpoint[1])
      response.get_and_unwrap("/services.#{endpoint[1]}",'services.service',{:jurisdiction_id => @options[:jurisdiction_id]})
      @raw << response
    end
  end
  
  def definition_resource
    @raw = []
    @session.raw_services.each do |raw_service|
      raw_service.response.each do |service|
        next if !service.metadata or service.metadata == 'false'
        response = Client.new(raw_service.base,raw_service.format)
        response.get_and_unwrap("/services/#{service.service_code}.#{raw_service.format}",'',{:jurisdiction_id => @options[:jurisdiction_id]})
        @raw << response
      end
    end
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
      @raw.xml << Client.new.post("#{endpoint.url}/requests.xml",data_from_options)
    end
    
    @session.discovery.json.response.endpoints.each do |endpoint|
      next if type(endpoint) == 'production' and !@options.production
      @raw.json << Client.new.post("#{endpoint.url}/requests.json",data_from_options)
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
  

  
  private
  

  
end