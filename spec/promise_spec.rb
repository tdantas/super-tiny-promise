require 'spec_helper'

describe Promise do

  it "starts with pending state" do 
    p = Promise.new
    expect(p.pending?).to eql(true)
  end

  it "responds to then" do 
    p = Promise.new
    expect(p).to  respond_to(:then)
  end

  context "#then" do 
    it "accepts success callback" do 
      p = Promise.new
      success = proc {}
      p.then success
      expect(p.callback?).to eql(true)
    end

    it "accepts error callback" do 
      p = Promise.new
      success = proc {}
      error = proc {}
      p.then nil, error 
      expect(p.errorback?).to eql(true)
    end

    it "accepts without callbacks" do 
      p = Promise.new
      p.then
      expect(p.errorback?).to eql(false)
      expect(p.callback?).to  eql(false)
    end

    it "returns a promise" do 
      p = Promise.new
      expect(p.then).to be_an(Promise)
    end
  end

  context "when fulfilled" do 

    it " must call callback once" do 
      result = []
      success = proc { |val| result.push(val) }
      p = Promise.new
      p.then success
      p.fulfill(10)
      p.fulfill(20)
      expect(result.length).to  eql(1)
      expect(result[0]).to eql(10)
    end

    it "changes state" do 
      p = Promise.new
      p.fulfill(12)
      expect(p.fulfilled?).to eql(true)
    end

    it "executes then in order with the same value" do 
      result = []
      first   = proc { |val| result.push(val + 1)}
      second  = proc { |val| result.push(val + 2)}
      third   = proc { |val| result.push(val + 3)}
      p = Promise.new
      p.then first
      p.then second
      p.then third
      p.fulfill(10)
      expect(result.length).to eql(3)
      expect(result).to eql([11,12,13])
    end

    it "ignores reject when already" do
      p = Promise.new
      r = []
      error = proc { |reason| r.push(reason)}
      p.then nil, error
      p.fulfill(12)
      p.reject(-1)
      expect(r.empty?).to eql(true)
    end
  end

  context "when rejected" do
    
    it "must call errorback once" do 
      result = []
      errorback = proc { |reason| result.push(reason) }
      p = Promise.new
      p.then nil, errorback
      p.reject('sorry')
      #p.reject('thank')
      expect(result.length).to  eql(1)
      expect(result[0]).to eql('sorry')
    end

    it "changes state" do 
      p = Promise.new
      p.reject('sorry')
      expect(p.rejected?).to eql(true)
    end

    it "executes then in order with the same reason" do 
      result = []
      first   = proc { |val| result.push(val + 1)}
      second  = proc { |val| result.push(val + 2)}
      third   = proc { |val| result.push(val + 3)}
      p = Promise.new
      p.then nil, first
      p.then nil , second
      p.then nil , third
      p.reject(10)
      expect(result.length).to eql(3)
      expect(result).to eql([11,12,13])
    end

  end 

end