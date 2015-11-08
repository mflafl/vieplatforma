class Video
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :file_path, type: String

  @uploads_dir = "public/uploads"
  @video_allowed_types = ["video/mp4"]

  validates_presence_of :title, :file_path

  def self.valid_file_type? (type)
    return @video_allowed_types.include? type
  end

  def self.get_file_destination_path(uploaded_file)
    file_extension = File.extname uploaded_file.path
    file_basename = File.basename(uploaded_file.original_filename, file_extension)

    destination = File.join(@uploads_dir, uploaded_file.original_filename)
    counter = 0

    while File.exist? destination
      destination = File.join(@uploads_dir,
                              sprintf("%<basename>s_%<counter>d%<extension>s",
                                      basename: file_basename, counter: counter,
                                      extension: file_extension))
      counter += 1
    end
    destination
  end

end