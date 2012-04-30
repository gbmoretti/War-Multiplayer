class Bucket

  def self.bucket
    @@bucket ||= []
  end
  
  def self.add(o)
    self.bucket.push(o)
  end
  
  def self.rem(o)
    self.bucket.delete(o)
  end

  def self.list
    self.bucket
  end

end 
