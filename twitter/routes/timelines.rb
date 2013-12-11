class TwitterBackshop < Sinatra::Base

  get '/timeline' do
    @timeline = current_user.timeline
    erb :timeline
  end
  
end