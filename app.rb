require "sinatra"
require "gschool_database_connection"
require "active_record"
require "rack-flash"


class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])

  end

  get "/" do
    erb :root
  end

  post "/registration" do
    if params[:email] == '' && params[:password] == ''
      flash[:registration] = "Please fill in email and password"
      redirect "/registration"
    elsif params[:password] == ''
      flash[:registration] = "Please fill in password"
      redirect "/registration"
    elsif params[:email] == ''
      flash[:registration] = "Please fill in email"
      redirect "/registration"
    else
      if @database_connection.sql("SELECT id FROM users WHERE email = '#{params[:email]}'") != []
        flash[:registration] = "email is already in use, please choose another."
        redirect "/registration"
      end
      flash[:notice] = "Thank you for registering"
      @database_connection.sql("INSERT INTO users (email, password) VALUES ('#{params[:email]}', '#{params[:password]}')")
      redirect "/"
    end
  end

  post "/login" do
    @order_user_string = "SELECT email,id FROM users"
    current_user = @database_connection.sql("SELECT * FROM users WHERE email='#{params[:email]}' AND password='#{params[:password]}';").first
    session[:user_id] = current_user["id"]
    flash[:not_logged_in] = true
    flash[:login] = "Welcome!"
    erb :login, :locals => {:send => @order_user_string}
  end

  post "/logout" do
    session[:user_id] = nil
    redirect "/"
  end

end
