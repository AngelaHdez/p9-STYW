require 'sinatra'
require 'rubygems'
require 'sass'
require 'pp'
require 'haml'
require './juego.rb'


settings.port = ENV['PORT'] || 4567
#enable :sessions

use Rack::Session::Pool, :expire_after => 2592000
set :session_secret, 'super secret'

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

DataMapper.auto_upgrade!

#configure :development, :test do
#  set :sessions, :domain => 'example.com'
#end

#configure :production do
#  set :sessions, :domain => 'herokuapp.com'
#end

module TicTacToe
  HUMAN = CIRCLE = "circle" # human
  COMPUTER = CROSS  = "cross"  # computer
  BLANK  = ""

  HORIZONTALS = [ %w{a1 a2 a3},  %w{b1 b2 b3}, %w{c1 c2 c3} ]
  COLUMNS     = [ %w{a1 b1 c1},  %w{a2 b2 c2}, %w{a3 b3 c3} ]
  DIAGONALS   = [ %w{a1 b2 c3},  %w{a3 b2 c1} ]
  ROWS = HORIZONTALS + COLUMNS + DIAGONALS
  MOVES       = %w{a1    a2   a3   b1   b2   b3   c1   c2   c3}

  def number_of(symbol, row)
    row.find_all{ |s| session["bs"][s] == symbol }.size 
  end

  def inicializa
    @board = {}
    MOVES.each do |k|
      @board[k] = BLANK
    end
    @board
  end

  def juego
    session["juego"]
  end


  def board
    session["bs"]
  end

  def [] key
    board[key]
  end

  def []= key, value
    board[key] = value
  end

  def each 
    MOVES.each do |move|
      yield move
    end
  end

  def legal_moves
    m = []
    MOVES.each do |key|
      m << key if board[key] == BLANK
    end
    puts "legal_moves: Tablero:  #{board.inspect}"
    puts "legal_moves: m:  #{m}"
    m # returns the set of feasible moves [ "b3", "c2", ... ]
  end

  def winner
    ROWS.each do |row|
      circles = number_of(CIRCLE, row)  
      puts "winner: circles=#{circles}"
      return CIRCLE if circles == 3  # "circle" wins
      crosses = number_of(CROSS, row)   
      puts "winner: crosses=#{crosses}"
      return CROSS  if crosses == 3
    end
    false
  end

  def smart_move
    moves = legal_moves

    ROWS.each do |row|
      if (number_of(BLANK, row) == 1) then
        if (number_of(CROSS, row) == 2) then # If I have a win, take it.  
          row.each do |e|
            return e if board[e] == BLANK
          end
        end
      end
    end
    ROWS.each do |row|
      if (number_of(BLANK, row) == 1) then
        if (number_of(CIRCLE,row) == 2) then # If he is threatening to win, stop it.
          row.each do |e|
            return e if board[e] == BLANK
          end
        end
      end
    end

    # Take the center if open.
    return "b2" if moves.include? "b2"

    # Defend opposite corners.
    if    self["a1"] != COMPUTER and self["a1"] != BLANK and self["c3"] == BLANK
      return "c3"
    elsif self["c3"] != COMPUTER and self["c3"] != BLANK and self["a1"] == BLANK
      return "a1"
    elsif self["a3"] != COMPUTER and self["a3"] != BLANK and self["c1"] == BLANK
      return "c1"
    elsif self["c1"] != COMPUTER and self["c3"] != BLANK and self["a3"] == BLANK
      return "a3"
    end
    
    # Or make a random move.
    moves[rand(moves.size)]
  end

  def human_wins?
    winner == HUMAN
  end

  def computer_wins?
    winner == COMPUTER
  end

  def tie?
    ((winner != COMPUTER) && (winner != HUMAN))
  end
end

helpers TicTacToe

get "/" do 
  puts "entro aqui"
  session["bs"] = inicializa()
  haml :game, :locals => { :b => board, :m => 'A jugar'  }
end

get %r{^/([abc][123])?$} do |human|
  if human then
    puts "You played: #{human}!"
    puts "session: "
    pp session
    if legal_moves.include? human
      board[human] = TicTacToe::CIRCLE
      # computer = board.legal_moves.sample
      computer = smart_move
      return '/humanwins' if human_wins?
      return '/tie' unless computer
      board[computer] = TicTacToe::CROSS
      puts "I played: #{computer}!"
      puts "Tablero:  #{board.inspect}"
      return '/computerwins' if computer_wins?
      resultado = computer
    end
  else
    session["bs"] = inicializa()
    puts "session = "
    pp session
    resultado = "illegal"
  end
  puts resultado
  resultado
  #haml :game, :locals => { :b => board, :m => ''  }
end


get '/humanwins' do
  puts "/humanwins session="
  begin
    m = if human_wins? then
          if (session["juego"] != nil)
          usu_juego = Juego.first(:nombre => session["juego"])

          usu_juego.p_ganadas = usu_juego.p_ganadas+1
          usu_juego.jugadas = usu_juego.jugadas+1
          usu_juego.save
          pp usu_juego

          end
          puts "alsdjflasdjflajsdlfkajsdlfjdkfjasdjflkasjdflkasldkfjadkfjljfl"
          'Bart wins'
        else 
          puts "locuroooooooooooooooooooon"
          redirect '/'
        end
    haml :final, :locals => { :b => board, :m => m }
  rescue
    puts "peppppppppeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
    redirect '/'
  end
end

get '/tie' do
  puts "/tie session="
  begin
    m = if tie? then
          if (session["juego"] != nil)
          usu_juego = Juego.first(:nombre => session["juego"])
          
          usu_juego.p_empatadas = usu_juego.p_empatadas + 1
          usu_juego.jugadas = usu_juego.jugadas + 1
          usu_juego.save
          pp usu_juego

          end
          puts "alsdjflasdjflajsdlfkajsdlfjdkfjasdjflkasjdflkasldkfjadkfjljfl"
          'TIE'
        else 
          puts "locuroooooooooooooooooooon"
          redirect '/'
        end
    haml :final, :locals => { :b => board, :m => m }
  rescue
    puts "peppppppppeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
    redirect '/'
  end
end


get '/computerwins' do
  puts "/computerwins session="
  begin
    m = if computer_wins? then
          if (session["juego"] != nil)
          usu_juego = Juego.first(:nombre => session["juego"])
          
          usu_juego.p_perdidas = usu_juego.p_perdidas + 1
          usu_juego.jugadas = usu_juego.jugadas + 1
          usu_juego.save
          pp usu_juego

          end
          puts "coooooooooooooooooooomputerrrrrrrrrrrrrrrrrr"
          'Bob Wins'
        else 
          puts "No puedes pasar"
          redirect '/'
        end
    haml :final, :locals => { :b => board, :m => m }
  rescue
    puts "peppppppppeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee2"
    redirect '/'
  end
end


post '/post' do
  if params[:logout]
    @juego = nil
    session["juego"] = nil
    session.clear
  else
    nick = params[:juego]
    nick = nick["nombre"]
    u = Juego.first(:nombre => "#{nick}")

    if u == nil
      usuario = Juego.create(params[:juego])

      usuario.p_perdidas = 0
      usuario.p_empatadas = 0
      usuario.p_ganadas = 0
      usuario.jugadas = 0

      usuario.save
      Aux = params[:juego]
      @juego = Aux["nombre"]
      session["juego"] = @juego
      puts "estoy entrando al if "
    else
      pass = params[:juego]
      password = pass["contraseña"]
      p_nombre = pass["nombre"]
      pp password

      u = Juego.first(:nombre => "#{nick}")
      a = u["nombre"]
      c = u["contraseña"]
      pp u
      pp c

      if a == p_nombre
        if password == c
          puts "es la misma persona"
          @juego = p_nombre
          session["juego"] = @juego
          
        else
          puts "no es la misma"
          @juego = nil
          session["juego"] = nil
          session.clear
        end
      end
      
    end
  end
    redirect '/'
end



not_found do
  puts "not found!!!!!!!!!!!"
  session["bs"] = inicializa()
  haml :game, :locals => { :b => board, :m => 'Let us start a new game'  }
end

get '/styles.css' do
  scss :styles
end


