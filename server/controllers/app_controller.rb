#Classe primitiva de todos os controllers.
#Aqui podem ser implementados métodos usados em todos os controllers.
class AppController

  attr_reader :app

  def initialize(app)
    @app = app
    @events = {}
    puts 'Controlller iniciado... ' + self.to_s
  end

  def register_event(game,msg)
    @events[game] = [] if @events[game].nil?
    @events[game].delete_at(0) if @events[game].count == 8
    @events[game].push msg
    @app.send(game.players,Message.new('events','refresh',{'events' => @events[game]}))
    
    puts @events[game].inspect
  end
  
  
end
  
