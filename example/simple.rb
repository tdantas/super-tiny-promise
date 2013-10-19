$: << '../lib'
require 'promise'
require 'thread'
require 'open-uri'

def with_board(title = "",&block)
  if block_given?
    header = [ ("-"* 20), " #{title} ", ("-"* 20) ].join("")
    puts  header
      block.call 
    puts "-" * header.length
  end
end


content_type = proc do |f| 
  with_board('content-type') do 
    p f.content_type
  end
end

base_uri = proc do |f|
  with_board('base_uri') do 
    p f.base_uri
  end
end 

promise = Promise.new

t = Thread.new do 
  open("http://blog.tdantas.com") do |f|
    promise.fulfill(f)
  end
end

promise.then(content_type).then(base_uri)

puts "Waiting for Tread finish"
t.join


