class VideoController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  def initialize
    @uploads_dir = "public/uploads"
  end

  def index
    #video = Video.new
    #video.title = "My video"
    #video.save
    #test = {:test => "rr"}
    #render json: test
  end

  def create
    #puts request

    #puts JSON.parse(request.body.read)
    #puts request.body.read

    if request.request_parameters[:files]
      request.request_parameters[:files].each do |file|
        uploaded_file = file[1];

        tmp_path = uploaded_file.path
        file_extension = File.extname uploaded_file.path
        file_basename = File.basename(uploaded_file.original_filename, file_extension)
        destination = File.join(@uploads_dir, uploaded_file.original_filename)

        counter = 0
        while File.exist? destination
          destination = File.join(@uploads_dir, sprintf("%<basename>s_%<counter>d%<extension>s",
                                basename: file_basename, counter: counter, extension: file_extension))
          counter += 1
        end

        FileUtils.move tmp_path, destination
      end
    end

  end
end
