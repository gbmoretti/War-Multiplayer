class Collection

  def initialize
    @bucket = []
  end
 
  def add(o)
    @bucket.push(o)
    o.__send__(:id=, @bucket.size) if o.respond_to?(:id) #injeta ID no objeto se ele tem esse atributo publico
  end
  
  def rem(o)
    @bucket.delete(o)
  end

  def list
    @bucket
  end

end 
