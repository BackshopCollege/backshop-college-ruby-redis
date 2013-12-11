require 'spec_helper'

describe 'User' do 

  context '#create' do 
    
    it 'with email' do 
      user = User.create('thiago@dantas.com', 'password')
      expect(user).to eql(User.find_by_email('thiago@dantas.com'))
    end

    it 'returns false with invalid email' do 
      expect(nil).to eql(User.find_by_email('whatever@dantas.com'))
    end

  end

  context "#twitte" do 
    
    before(:each) do
      @user = User.create('thiago@gmail.com')
    end

    it 'publishs a new twitte' do 
      @twitte = @user.twitte('my content')
      expect(@twitte.published?).to eql(true)
    end

    it 'associate twitte to user' do 
      @twitte = @user.twitte('hey!')
      expect(@twitte.owner.id).to eql(@user.id)
    end

  end

  context "#follow" do

    before(:each) do 
      @user = User.create('thiago@gmail.com')
      @other = User.create('other@gmail.com')
    end
    
    it 'enable follow other user' do 
      @user.follow(@other)
      expect(@user.followings.length).to eql(1)
      @user.followings.each do |other_user|
        expect(other_user.id).to eql(@other.id)
      end
    end

    it 'when follow the other user has another follower' do 
      @user.follow(@other)
      expect(@other.followers.length).to eql(1)
      @other.followers.each do |follower| 
        expect(follower.id).to eql(@user.id)
      end
    end
  end
end