require 'thread'
require 'callback'
class Promise

  def initialize
    @value  = nil
    @state  = :pending
    @callbacks  =  [ ]
    @errorbacks =  [ ]
  end

  def then(onFulfilled = nil, onRejected = nil)
    push_errorback onRejected
    push_callback  onFulfilled

    if fulfilled? or rejected?
      run_callbacks
    end

    self
  end

  def fulfill(value)
    if pending?
      @value = value       
      @state = :fulfilled
      run_callbacks
    end
  end

  def reject(value)
    if pending?
      @value = value 
      @state  = :rejected
      run_callbacks
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

  def push_errorback(onRejected)
    @errorbacks.push(Callback.new(onRejected))  if valid_callback?(onRejected)
  end

  def push_callback(onFulfilled)
    @callbacks.push(Callback.new(onFulfilled))  if valid_callback?(onFulfilled)
  end

  def run_callbacks
    callbacks = fulfilled? ? @callbacks : @errorbacks
    callbacks.each do |callback|
      callback.call(@value)
    end
  end

end