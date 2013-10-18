$: << '../lib'
require 'promise'
require 'thread'
require 'open-uri'

promise = Promise.new

def with_board(title = "",&block)
  if block_given?
    header = [ ("-"* 20), " #{title} ", ("-"* 20) ].join("")
    puts  header
      block.call 
    puts "-" * header.length
  end
end

content_type = proc do |value| 
  with_board('content-type') do 
    p value
  end
end

content_type = proc do |f| 
  with_board('content-type') do 
    p f.content_type
  end
  return  f
end

base_uri = proc do |f|
  with_board('base_uri') do 
    p f.base_uri
  end
end 

promise.then(content_type)
promise.then(base_uri)

Thread.new do 
  open("http://www.google.com") do |f|
    promise.fulfill(f)
  end
end.join

