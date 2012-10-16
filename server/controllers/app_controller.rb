#Classe primitiva de todos os controllers.
#Aqui podem ser implementados métodos usados em todos os controllers.
class AppController

  attr_reader :app

  def initialize(app)
    @app = app
    puts 'Controlller iniciado... ' + self.to_s
  end

    
end
  
