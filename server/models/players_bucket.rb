class PlayersBucket < Bucket

  def self.get_by_sid(sid)
    i = super.bucket.index { |p| p.sid == sid }
    super.bucket[i]
  end
   
end
 
