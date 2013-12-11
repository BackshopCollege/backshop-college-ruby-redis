require 'spec_helper'

describe Timeline do 

  context "#belongs to user" do 

    it 'contains the user' do
      user = User.create('thiago@gmail.com')
      timeline = Timeline.new(user.id)
      expect(timeline.owner.id).to eql(user.id)
    end

  end

  context '#twittes'  do 
    
    before(:each) do 
      @thiago       = User.create('thiago@gmail.com')
      @timeline     = Timeline.new(@thiago.id)
    end

    it 'returns my own twitters' do 
      @thiago.twitte('hey!')
      @timeline.twittes.each do |twitte|
        expect(@thiago.id).to eql(twitte.owner.id)
      end
      expect(@timeline.twittes.length).to eql(1)
    end

    it 'returns all my followings twittes' do 
      mali = User.create('mali@gmail.com')
      
      @thiago.follow(mali)
      mali.twitte('who lets the dog out!')

      expect(1).to eql(@timeline.twittes.length)
      @timeline.twittes.each do |twitte|
        expect(twitte.owner.id).to eql(mali.id)
      end

    end
    
    it 'does not return twitte from other user that I do not follow' do 
      other_user = User.create('anyother@gmail.com')
      other_user.twitte('singing in the rain')
      expect(@timeline.twittes.length).to eql(0)
    end

    context "pagination" do 
      
      it 'returns first 3 twittes' do
        pending
      end

      it 'returns the second twittes page' do 
        pending
      end
    end

  end
end