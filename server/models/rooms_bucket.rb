class RoomsBucket < Bucket

  def self.get_instance
    @@instance ||= self.new
  end

  #sobrescrevendo o método add para atualizar atributo ID do objeto
  def add(o)
    super(o)
    o.id = @bucket.size-1
  end

  def get_by_index(i)
    @bucket[i]
  end

end
