# SPEC http://promises-aplus.github.io/promises-spec/

class APlus
  def self.create(&block)
    promise = new
    block.call(promise)
    promise
  end

  def initialize
    @state = :unfulfilled
    @result  = nil
    @thens = []
  end

  def then(&callback)
    @thens << callback
     react if @state == :filfilled
  end

  def resolve(val)
    @result = val if @state == :unfulfilled
    react rescue  
    @state = :fulfilled
  end

  private
  def react
    val = @result
    @thens.each do |callback|
      val = callback.call(val)
    end
  end

end

t = nil
promise = Promise.create do | promise |
  
  t = Thread.new do 
    sleep 5
    promise.resolve('thiago')
  end

end

callback = proc { |r| puts r }
callback2 = proc { |r| puts  }

promise.then(&callback).then()

t.join

