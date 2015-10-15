class Video
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :filename, type: String

  validates_presence_of :title, :filename

end
