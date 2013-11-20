require 'uri'

class Params
  def initialize(req, route_params = {})
    qs = req.query_string
    body = req.body

    @params = route_params
    parse_www_encoded_form(qs) unless qs.blank?
    parse_www_encoded_form(body) unless body.blank?

    #puts @params
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_json
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    URI.decode_www_form(www_encoded_form).each do |key, value|
      parse_key(key, value)
    end
  end

  def parse_key(key, value)
    keys = key.split(/\]\[|\[|\]/)

    current_level = @params
    (0...(keys.length-1)).each do |i|
      k = keys[i]
      current_level[k] = {} if current_level[k].nil?
      current_level = current_level[k]
    end

    current_level[keys.last] = value
  end
end