
class Session
  
  def initialize
    @resources = []
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
  
  def prev_resource
    @resources[@resources.count-2]
  end
  
  def add_resource(options)
    @resources << Resource.new(self,options).get
  end
  
end