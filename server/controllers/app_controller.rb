class AppController

  attr_reader :app

  def initialize(app)
    @app = app
    puts 'Controlller iniciado... ' + self.to_s
  end

    
end
  
