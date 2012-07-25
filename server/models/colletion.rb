class Colletion

  def initialize
    @bucket = []
  end
 
  def add(o)
    @bucket.push(o)
  end
  
  def rem(o)
    @bucket.delete(o)
  end

  def list
    @bucket
  end

end 
