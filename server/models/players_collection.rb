class PlayersCollection < Collection

  def self.get_instance
    @@instance ||= self.new
  end

  def get_by_sid(sid)
    i = super.bucket.index { |p| p.sid == sid }
    super.bucket[i]
  end
   
end
 
