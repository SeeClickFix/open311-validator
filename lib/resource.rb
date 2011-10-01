

class Resource
  
  def initialize(last_resource,options)
    @options = options
    @raw = OpenStruct.new
    @last_resource = last_resource
  end
  
  def get
    self.send @options.with
  end
  
  def discovery_resource
    @raw.json = Response.new("#{@options.discovery_url}.json") if @options.json
    @raw.xml  = Response.new("#{@options.discovery_url}.xml")
    @raw.options = @options
    @raw
  end
  
  def services_resource
    @raw.json = []
    @raw.xml  = []
    # For each endpoint...
    @last_resource.xml.response.discovery.endpoints.endpoint.each do |endpoint|
      next if silently{endpoint.type} == 'production' and !@options.production
      @raw.xml << Response.new("#{endpoint.url}/services.xml?jurisdiction_id=#{@options.jurisdiction_id}")
    end
    
    @last_resource.json.response.endpoints.each do |endpoint|
      next if silently{endpoint.type} == 'production' and !@options.production
      @raw.json << Response.new("#{endpoint.url}/services.xml?jurisdiction_id=#{@options.jurisdiction_id}")
    end if @options.json
    
    @raw.options = @options
    @raw
  end
  
  def definition_resource
    @raw.json = []
    @raw.xml  = []
    # For each endpoint...
    @last_resource.xml.each do |service_list|
      service_list.response.services.each do |service|
        next unless service.metadata
        @raw.xml << Response.new("#{service.url}/services/#{service.service_code}.xml?jurisdiction_id=#{@options.jurisdiction_id}")
      end
    end
    
    @last_resource.json.each do |service_list|
      service_list.response.services.each do |service|
        next unless service.metadata
        @raw.json << Response.new("#{service.url}/services/#{service.service_code}.xml?jurisdiction_id=#{@options.jurisdiction_id}")
      end
    end if @options.json
  
    @raw.options = @options
    @raw
  end
  
  # This silences the type method of the service instance, which throws deprication warnings in ruby.
  def silently(&block)
    warn_level = $VERBOSE
    $VERBOSE = nil
    begin
      result = block.call
    ensure
      $VERBOSE = warn_level
    end
    result
  end
  
end