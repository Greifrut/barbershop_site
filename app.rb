require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def if_barber_existst? db, name
  db.execute('select * from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers

  barbers.each do |barber|
    if !if_barber_existst? db, barber
      db.execute 'insert into Barbers (name) values (?)', [barber]
    end
  end

end

def get_db
 db = SQLite3::Database.new 'barbershop.db'
 db.results_as_hash = true
 return db
end

before do
  db = get_db
  @barbers = db.execute 'select * from Barbers'
end

configure do
  db = get_db
  db.execute 'create table if not exists
   "Barbers"
   ("id" integer primary key autoincrement,
    "name" text
    )'

    seed_db db,['Jessy Pinkman','Walter White','Gus Fing']
end


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

get '/showuser' do
  db = get_db
  @results = db.execute 'select * from Users order by id desc'

  erb :showuser
end

post '/visit' do
  @user_name = params[:user_name]
  @date = params[:date]
  @phone = params[:phone_number]
  @parik = params[:parik]
  @color = params[:color]

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

  db = get_db
  db.execute 'insert into Users (username, phone, DateStamp, barber, color) 
       values (?,?,?,?,?)', [@user_name, @phone, @date, @parik, @color]
  
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
  end

  @contacts = File.open "./public/contacts.txt", 'a'
  @contacts.write "Email: #{@email}, Сообщение: #{@message}.     "
  @contacts.close

  erb :contacts
end
