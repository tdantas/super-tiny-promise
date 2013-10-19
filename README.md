super light tiny promises
=======

Promise Implementation A+ (incomplete) #irresponsibleruby

Just to implement promises following the CommonJS Specs.

###### Not yet **Chainable - most known as Thenable **

````

 #content-type callback
 callback_content_type = proc do |f| 
   p f.content_type
 end

 #base-uri callback
 callback_base_uri = proc do |f|
   p f.base_uri
 end 

 promise = Promise.new

 t = Thread.new do 
   open("http://blog.tdantas.com") do |f|
     promise.fulfill(f)
   end
 end

 promise.then(content_type).then(base_uri)

 t.join  #waiting the thread before finish

````


## Todo

* Thenanble
* Build the Promise Resolution Procedure properly