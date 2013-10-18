class Callback
  
  def initialize(promise,callable)
    @state = :new
    @callable = callable
    @thenable = promise
  end

  def call(val)
    if @state == :new
      begin
        result = @callable.call(val)
        @state = :end
        run_promise(result)
      rescue StandardError => e 
        reject(e)
      end
    end
  end

  private
  def run_promise(val)
    @thenable.fulfill(val)
  end

  def reject(reason)
    @thenable.reject(reason)
  end

end