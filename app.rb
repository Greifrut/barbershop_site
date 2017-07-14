require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pony'

get '/' do
  erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has lite version"
end

get '/about' do
  erb :about
end

get '/visit' do
  erb :visit
end

get '/contacts' do
  erb :contacts
end

get '/login' do
  erb :login
end


post '/visit' do
  @user_name = params[:user_name]
  @date = params[:date]
  @phone = params[:phone_number]
  @parik = params[:parik]

  hh = {:user_name => 'Введите имя',
        :phone => 'Введите телефон',
        :@date => 'Введиет дату  время',
      }
  hh.each do |key, value|
    if params[key] == ""
      @error = hh[key]
      return erb :visit
    end
  end



  @file = File.open "./public/user.txt", "a"
  @file.write "Имя: #{@user_name}, Дата: #{@date}, Номер телефона: #{@phone}. Парикмахер: #{@parik}   "
  @file.close

  erb :visit
end

post '/contacts' do
  @email = params[:email]
  @message = params[:message]

  hh = {@email => 'Введите email',
        @message => 'Введите текст сообщения',
        }

  hh.each do |key,value|
    if params[key] == ''
      @error == hh[key]
      return erb :contacts
    end

  @contacts = File.open "./public/contacts.txt", 'a'
  @contacts.write "Email: #{@email}, Сообщение: #{@message}.     "
  @contacts.close

  erb :contacts
end

post '/login' do
  @login = params[:login]
  @pass = params[:password]

  if @login == "admin" && @pass == "secret"
    './public/user.txt'
  else
    erb :login
  end
end
