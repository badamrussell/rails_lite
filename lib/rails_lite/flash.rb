
class Flash
  def initialize
    @flash = { errors: [], notice: [] }
  end

  def [](key)
    @flash[key]
  end

  def []=(key, value)
    @flash[key] = value
  end
end