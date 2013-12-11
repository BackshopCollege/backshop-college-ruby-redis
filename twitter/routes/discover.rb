class TwitterBackshop < Sinatra::Base

  helpers Sinatra::JSON

  get '/discover' do 
    erb :discover
  end

  post '/discover' do
    @user = User.find_by_email(params[:email])
    if @user 
      json status: 'true', user: { email: @user.email, id: @user.id } 
    else
      json status: 'false'
    end

  end
end  