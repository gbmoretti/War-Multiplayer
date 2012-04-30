class RoomsBucket < Bucket

  def self.get_by_index(i)
    super.bucket[i]
  end

end
