
class PositiveSpec
  def initialize(obj,required)
    @obj = obj
    @required = required
  end
  
  def ==(other)
    if @obj != other
      raise Exception.new("#{requirement}: \"Expected: #{other} Got: #{@obj}\"")
    end
  end

  def >(other)
    unless @obj > other
      raise Exception.new("#{requirement}: \"Expected: #{other} Got: #{@obj}\"")
    end
  end
  
  def requirement
    @required ? "REQUIRED" : "WARNING"
  end
end

class NegativeSpec
  def initialize(obj,required)
    @obj = obj
    @required = required
  end
  
  def ==(other)
    if @obj == other
      raise Exception.new("#{requirement}: \"Expected: #{other} Got: #{@obj}\"")
    end
  end
  
  def requirement
    @required ? "REQUIRED" : "WARNING"
  end
end

class Object
  def should
    PositiveSpec.new(self,false)
  end
  
  def should_not
    NegativeSpec.new(self,false)
  end
  
  def must
    RequiredPositiveSpec.new(self,true)
  end
  
  def must_not
    RequiredNegativeSpec.new(self,true)
  end
end

module Helper

  def self.validate_date_time(time)
    return true if Time.iso8601(time) rescue false
  end

end

def rule(msg)
  begin
    yield
    print "\tRule: #{msg.to_s.lstrip.ljust(50)[0..50]}"," - PASSED"
  rescue Exception => e
    print "\tRule: #{msg.to_s.lstrip.ljust(50)[0..50]} - FAILED - #{e.to_s}"
  end
  puts ""
end

def test(msg,options)
  puts "Testing - #{msg.to_s}"
  @session.add_resource OpenStruct.new(@options.merge(options))
  @resource = @session.resource
  yield
end