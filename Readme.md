Building a Simple Sinatra Tic-Tac-Toe game 
==================================================

App currently contains:

* app.rb - the application code
* Gemfile - specifies the gems this app relies on
* Gemfile.lock - automatically generated dependancy file
* views/ - this is the default folder for erb views
* layout.erb - this is the default layout to be used for all erb files
* public/ - this is the default folder for serving static assets
* Procfile - this tells Heroku or Foreman how to run the application
* Rakefile- installs the gems and run the server

1. Objetivo
-----------
	
	Añadir una base de datos a la práctica del TicTacToe de manera que se lleve la cuenta de los usuarios registrados, las partidas jugadas, ganadas y perdídas. 

	Mejorar las hojas de estilo usando SAAS . Deberán mostrarse las celdas pares e impares en distintos colores. También deberá mostrarse una lista de jugadores con sus registros.

	Despliegar la aplicación en Heroku. 


IMPORTANTE
==========

2. Instalar:
------------

	sudo apt-get install libecpg-dev
	sudo apt-get install postgresql-client
	sudo apt-get install postgresql

3. Ejecucción
-------------

	rake css (cuando se modifica el css de la aplicación)
	rake (arrancarla en local)

4. Mostrar aplicación
---------------------
	Local: htpp://localhost:4567

	Heroku: http://intense-reaches-6581.herokuapp.com/
