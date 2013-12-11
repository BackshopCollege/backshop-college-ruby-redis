class TwitterBackshop < Sinatra::Base

  get '/users/follow/:other_user_id' do 
    current_user.follow(User.new(params[:other_user_id]))
    redirect '/timeline'
  end

end