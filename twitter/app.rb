require 'bundler/setup'
Bundler.require :default

require 'sinatra/base'
require "sinatra/json"

require_relative 'models/boot'
require_relative 'helpers/boot'
require_relative 'routes/boot'
require_relative 'components/boot'

class TwitterBackshop < Sinatra::Base

  enable :method_override
  enable :sessions
  set :session_secret, 'Super Mr. Backshop Secret Token by linkedcare. Check it out. http://www.mylinkedcare.com'
  
  set :app_file, __FILE__

  configure :development do
    enable :logging, :dump_errors, :raise_errors
  end

  configure :production do
    set :raise_errors, false 
    set :show_exceptions, false
  end

  register Sinatra::SessionAuth
  register Sinatra::AssetPack

  assets do

    serve '/js',     from: 'public/js'        # Default
    serve '/css',    from: 'public/css'       # Default

    js  :application, '/public/js/application.js', ['/js/jquery.js', '/js/underscore.js', '/js/**/*' ]
    css :application, '/public/css/application.css', [ '/css/bootstrap.css' ]

    js_compression  :jsmin    # :jsmin | :yui | :closure | :uglify
    css_compression :simple   # :simple | :sass | :yui | :sqwish
  
  end

  helpers do
    include Sinatra::SessionAuth
  end

  before /^(?!\/(signup|sign_in|js|css))/ do 
    puts 'before'
    puts "#{request.path_info}"
    authenticated!
  end

  get "/" do 
    if current_user.nil?
      redirect '/'
    else
      redirect '/timeline'
    end
  end

end




