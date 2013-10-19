$: << '../lib'
require 'promise'
require 'thread'
require 'open-uri'

content_type = proc do |f| 
  puts "ERROR if this you are reading this message"
end

on_failure = proc do |e| 
  puts "EXCEPTION => #{e}" 
end

on_failure_chain = proc do |e| 
  puts "BAD NEWS: #{e.message}" 
end

promise = Promise.new

t = Thread.new do 
  begin
    open("http://blog.xxx.yyy") do |f|
      promise.fulfill(f)
    end
  rescue Exception => e
    promise.reject(e)
  end
end

promise
  .then(content_type, on_failure)
  .then(content_type, on_failure_chain)


puts "Waiting for Tread finish"
t.join


