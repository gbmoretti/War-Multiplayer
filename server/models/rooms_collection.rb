class RoomsCollection < Collection

  def self.get_instance
    @@instance ||= self.new
  end

  def get_by_index(i)
    @bucket[i]
  end

end
