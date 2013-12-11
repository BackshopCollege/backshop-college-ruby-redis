class TwitterBackshop < Sinatra::Base

  get '/byebye' do
    logout!
    redirect '/sign_in'
  end

  get '/sign_in' do 
    erb :sign_in
  end

  post 'sign_in' do 
    email = params[:email]
    password = params[:password]
    
  end

end