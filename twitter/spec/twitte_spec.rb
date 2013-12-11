require 'spec_helper'

describe Twitte do
  
  before(:each) do 
    @user = User.create('thiago@twitte.com')
    @twitte = Twitte.new(content, @user.id)
    @twitte.publish
  end 

  let(:content) { 'Whatever Message' }
  
  it 'contains the content' do 
    expect(@twitte.content).to eql(content)
  end

  it 'contains the twitte owner' do
    expect(@user.id).to eql(@twitte.owner.id)
  end

end