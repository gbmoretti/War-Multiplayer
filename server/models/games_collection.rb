class GamesCollection < Collection
  
  def self.get_instance
    @@instance ||= self.new
  end
  
  
end
