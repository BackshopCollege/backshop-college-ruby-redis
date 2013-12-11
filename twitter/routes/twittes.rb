class TwitterBackshop < Sinatra::Base

  post '/twittes' do 
    @twitte = current_user.twitte(params[:content])
    redirect '/timeline'
  end

end