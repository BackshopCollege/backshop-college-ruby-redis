class Signup

  attr_accessor :email, :password, :password_confirmation, :errors

  def initialize(email, password, password_confirmation)
    @email = email
    @password = password
    @password_confirmation = password_confirmation
    clear_errors!
  end

  def register(cipher_strategy = ::PasswordMD5Cipher)
    
    if valid?
      @user = User.create(email, cipher_strategy.cipher!(password))
      return true
    end
    return false      
  end

  def user
    @user 
  end

  def valid?
    clear_errors!

    unique
    minimal_password_length
    password_confirmation_mismatch
    email_present
    
    @errors.empty?
  end

  private

    def clear_errors!
      @errors = Errors.new
    end

    def password_confirmation_mismatch
      @errors[:password] = 'Password Confirmation Mismatch' if password_confirmation != password
    end

    def minimal_password_length
      @errors[:password] = 'Minimal 6 letters' if password.strip.length < 6
    end

    def email_present
      @errors[:email] =  'Invalid email'  if email.strip.empty?
    end

    def unique
      @errors[:email] =  'Email already registered' if User.find_by_email(email)
    end

end