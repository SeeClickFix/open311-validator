

class Client
  attr_accessor :raw, :base, :format, :unwrap

  def initialize(base,format)
    @base = base
    @format = format
  end
  
  def get_and_unwrap(url,unwrap)
    @unwrap = unwrap
    get(url)
  end

  def get(url)
    @raw = HTTParty.get("#{@base}#{url}")
    self
  end
  
  def post(url,body)
    # TODO: remove. This is simply for my testing.
    url = 'http://localhost:3000/open311/requests.xml'
    @raw = HTTParty.post(url, :body => body)
    self
  end
  
  def response
    if @format == 'xml' and !@unwrap.nil?
      Array(Session.unwrap(raw_response,@unwrap))
    else
      raw_response
    end
  end
  
  def raw_response
    Client.hash2ostruct(@raw.parsed_response)
  end
  
  def headers
    Client.hash2ostruct(@raw.headers)
  end
  
  def body
    @raw.body
  end
  
  def request
    @raw.request
  end
  
  # Recursively create ostruct obj from 
  # httparty's Hash/Array mess.
  def self.hash2ostruct(object)
    return case object
    when Hash
      object = object.clone
      object.each do |key, value|
        object[key] = Client.hash2ostruct(value)
      end
      OpenStruct.new(object)
    when Array
      object = object.clone
      object.map! { |i| Client.hash2ostruct(i) }
    else
      object
    end
  end
  
end