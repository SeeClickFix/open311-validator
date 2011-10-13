
class Session
  attr_accessor :options
  
  def initialize(options)
    @resources = []
    @options   = {
      :production => false,
      :write      => false
    }.merge options
  end
  
  def run_tests
    load 'tests/discovery.rb'
    load 'tests/services.rb'
    load 'tests/service_definition.rb'
    #load 'tests/create.rb' if @options[:write]
  end
  
  def valid?
    @options[:discovery_url] && 
    !@options[:production].nil? &&
    !@options[:write].nil? &&
    !@options[:production].nil? &&
    (!@options[:write] || ( @options[:write] && !@options[:address].nil? ))
  end
  
  #
  #  Resource mgmt.
  def add_resource(options)
    resource = Resource.new(self,@options.merge(options))
    resource.get_next
    @resources << resource
  end
  
  def resources
    @resources
  end
  
  def discovery
    @resources.first
  end
  
  def resource
    @resources.last
  end
  
  # Endpoint mgmt.
  def endpoint_array
    t = []
    all_endpoints.each do |endpoint|
      Session.endpoint_formats_as_array(endpoint).each do |format|
        next if format =~ /^.*html$/i
        t << [endpoint.url,format]
      end
    end
    t
  end
  
  def self.endpoint_formats_as_array(endpoint)
    Session.endpoint_formats(endpoint).map{|format| format.to_s.split('/')[1]}
  end
  
  def self.endpoint_formats(endpoint)
    endpoint.formats.is_a?(Array) ? endpoint.formats : Array(Session.unwrap(endpoint,'formats.format'))
  end
  
  def all_endpoints
    json_endpoints + xml_endpoints
  end
  
  def json_endpoints
    Session.unwrap(discovery.raw.json, 'response.endpoints').select{|endpoint| production_safe?(endpoint) }
  end
  
  def xml_endpoints
    Array(Session.unwrap(discovery.raw.xml,'response.discovery.endpoints.endpoint')).select{|endpoint| production_safe?(endpoint) }
  end
  
  #
  #  Services Lookup
  #
  def services
    @resources[1].raw.map{|r| r.response }.flatten
  end
  
  def raw_services
    @resources[1].raw
  end
  
  # Class Methods
  def self.unwrap(obj,methods)
    methods.split('.').each do |method|
      obj = obj.send method.to_sym
    end
    obj
  end
  
  private
  
  # The marshal_dump is to avoid calling .type on the obj.
  def production_safe?(endpoint)
    endpoint.marshal_dump[:type] != 'production' or @options[:production]
  end
  
end