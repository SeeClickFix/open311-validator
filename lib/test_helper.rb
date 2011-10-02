
module TestHelper

  def validate_date_time(time)
    return true if Time.iso8601(time) rescue false
  end

  extend self
end