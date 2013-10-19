require 'thread'
require 'callback'
class Promise

  def initialize
    @value  = nil
    @state  = :pending
    @callbacks  =  [ ]
    @errorbacks =  [ ]
    @mutex = Mutex.new
  end

  def then(onFulfilled = nil, onRejected = nil)
    @callbacks.push(Callback.new(onFulfilled))  if valid_callback?(onFulfilled)
    @errorbacks.push(Callback.new(onRejected))  if valid_callback?(onRejected)
    
    if fulfilled? or rejected?
      run_callbacks
    end

    self
  end

  def fulfill(value)
    @mutex.synchronize do
      if pending?
        @value = value       
        @state = :fulfilled
        run_callbacks
      end
    end
  end

  def reject(value)
    @mutex.synchronize do
      if pending?
        @value = value 
        @state  = :rejected
        run_callbacks
      end
    end
  end

  def callback?
    ! @callbacks.empty?
  end

  def errorback?
    ! @errorbacks.empty?
  end

  def fulfilled?
    @state == :fulfilled
  end

  def rejected?
    @state == :rejected
  end

  def pending?
    @state == :pending
  end

  private 
  def valid_callback?(callback)
    (!!callback && callback.respond_to?(:call))
  end

  def run_callbacks
    callbacks = fulfilled? ? @callbacks : @errorbacks
    callbacks.each do |callback|
      callback.call(@value)
    end
  end

end