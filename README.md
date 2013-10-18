super light tiny promises
=======

Promise Implementation A+ (incomplete) #irresponsibleruby

Just to implement promises following the CommonJS Specs.

###### Not yet **Chainable - most known as Thenable **

````

promise = Promise.new

content_type = proc do |f| 
  puts f.content_type
  return  f
end

promise.then(content_type)

t = Thread.new do 
  open("http://www.google.com") do |f|
    promise.fulfill(f)
  end
end

puts "Waiting for Tread finish"
t.join


````

