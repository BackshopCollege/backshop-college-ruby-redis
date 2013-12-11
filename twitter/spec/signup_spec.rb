require 'spec_helper'

describe Signup do 

  context "#register" do

    before(:each) do 
      Signup.new('thiago@dantas.com', '123456', '123456').register
    end

    it 'returns false when invalid' do 
      signup = Signup.new('thiago@dantas.com', '123456', '123456')
      expect(signup.register).to be_false
    end

    it 'returns true when valid' do 
      signup = Signup.new('thiago-otheremail@dantas.com', '123456', '123456')
      expect(signup.register).to be_true
    end

  end

  context "new user" do 
    
    it "returns the user" do 
      signup = Signup.new('thiago@dantas.com', '123456', '123456')
      signup.register
      expect(signup.user).to eql(User.find_by_email('thiago@dantas.com'))
    end

  end

  context 'already user' do 
    
    before(:each) do
      @first_signup_password = '123456' 
      @first_signup  = Signup.new('thiago@dantas.com', @first_signup_password, @first_signup_password).tap do |s|
        s.register
      end

      @second_signup = Signup.new('thiago@dantas.com', @first_signup_password, @first_signup_password).tap do |s|
        s.register
      end

    end

    it 'does not override old users'  do 
      password_digest = ::PasswordMD5Cipher.cipher!(@first_signup_password)
      third_signup = Signup.new('thiago@dantas.com', 'password', 'password')
      third_signup.register

      expect(@first_signup.user.password).to eql(password_digest)
    end

    it 'returns the error message' do 
      expect(@second_signup.errors).not_to be_empty
    end

    it 'returns false when verify if valid' do 
      expect(@second_signup.valid?).to be_false  
    end

  end

  context 'invalid email' do 

    context "blank" do 
      
      before(:each) do 
        @signup = Signup.new('', 'password', 'password')
        @signup.valid?
      end

      it 'errors container not empty' do
        expect(@signup.errors).not_to be_empty
      end

      it 'errors field is email' do 
        expect(@signup.errors[:email]).not_to be_empty
      end

      it 'errors length is one' do 
        expect(@signup.errors.length).to eql(1)
      end
    end

    
  end

  context 'invalid password' do 
    
    context 'less than 6 letters' do 

      before(:each) do 
        @signup = Signup.new('thiago@email.com', '123', '123')
        @signup.valid?
      end
      
      it 'errors container not empty' do
        expect(@signup.errors).not_to be_empty
      end

      it 'errors field is password' do 
        expect(@signup.errors[:password]).not_to be_empty
      end

      it 'errors length is one' do 
        expect(@signup.errors.length).to eql(1)
      end

      it 'message length letters complain' do 
        expect(@signup.errors[:password]).to include('Minimal 6 letters')
      end

    end
  end

  context 'invalid password confirmation' do 

    it 'does not match' do 
      signup = Signup.new('thiago@email.com', '123456', '1234567')
      signup.register
      expect(signup.errors[:password]).to include('Password Confirmation Mismatch')
    end

  end

  context 'all errros' do 

    before(:each) do 
      @signup = Signup.new('', '1234', '123456')
    end

    it 'contain 3 errors' do 
      @signup.valid?
      expect(@signup.errors.length).to eql(3)
    end

  end
end