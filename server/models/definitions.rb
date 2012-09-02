class Definitions

  def self.get_instance
    @@instance ||= self.new
  end

  def colors
    get_from_file('war/colors')
  end

  def territories
    get_from_file('war/territories')
  end
  
  def regions
    get_from_file('war/regions')
  end

  def cards
    get_from_file('war/cards')
  end

  private
  def get_from_file(file)
    JSON.parse(File.open(File.expand_path("server/data/#{file}.json"), 'rb') { |file| file.read }) 
  end

end
