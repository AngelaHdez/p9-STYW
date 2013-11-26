require 'dm-core'
require 'dm-migrations'

class Juego
  include DataMapper::Resource
  property :id, Serial
  property :nombre, String
  property :contraseña, String
  property :p_ganadas, Integer
  property :p_perdidas, Integer
  property :p_empatadas, Integer
  property :jugadas, Integer
end

DataMapper.finalize


get '/juego' do
  @juego = Juego.all
  haml :juego
end