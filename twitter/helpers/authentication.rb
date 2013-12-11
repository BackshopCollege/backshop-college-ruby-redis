module Sinatra
  module SessionAuth

    module Helpers

      def authenticated!
        puts "REDIRECTING" 
        redirect to('/sign_in') if session['current_user'].nil?
      end

      def current_user
        User.new(session['current_user']) if session['current_user']
      end

      def logout!
        session.destroy
      end

    end

    def self.registered(app)
      app.helpers SessionAuth::Helpers
    end

  end

end