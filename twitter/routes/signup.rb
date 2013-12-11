class TwitterBackshop < Sinatra::Base

  get '/signup' do 
    erb :signup
  end
  
  post '/signup/register' do
    signup = Signup.new(params[:email], params[:password], params[:password_confirmation])
    
    unless signup.register
      @errors = signup.errors
      return  erb :signup
    end

    session['current_user'] = signup.user.id
    puts "Current = #{current_user}"
    redirect '/timeline'
  end

end