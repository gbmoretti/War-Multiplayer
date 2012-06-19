class PregameController < AppController

  def initialize(app)
    super(app)
  end

  def name
    :pregame
  end

  def show(player,room)
    @app.send(player,PregameShow.new(room))
  end

end
