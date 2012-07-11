class Game

  #singleton? acho que sim...
  def self.get_instance
    @@instance ||= self.new
  end

  def colors
    JSON.parse(File.open(File.expand_path('server/data/war/colors.json'), 'rb') { |file| file.read })    
  end

  def territories
    JSON.parse(File.open(File.expand_path('server/data/war/territories.json'), 'rb') { |file| file.read })  
  end

end
