class Callback
  
  def initialize(callable)
    @old = false
    @callable = callable
  end

  def call(val)
    unless @old
      @old = true
      @callable.call(val)
    end
  end

end