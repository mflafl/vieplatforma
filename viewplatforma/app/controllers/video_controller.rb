class VideoController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  def index

  end

  def create
    if request.request_parameters[:files]

      videos = [];

      request.request_parameters[:files].each do |file|
        uploaded_file = file[1];

        if (!Video.valid_file_type? uploaded_file.content_type)
          render json: "File type is invalid", status: :bad_request
        end

        file_extension = File.extname uploaded_file.path
        file_basename = File.basename(uploaded_file.original_filename, file_extension)
        destination = Video.get_file_destination_path uploaded_file

        video = Video.new({:title => file_basename, :file_path => destination})

        if video.valid?
          videos << video
        else
          render json: video.errors, status: :bad_request
        end

        tmp_path = uploaded_file.path
        FileUtils.move tmp_path, destination
      end

      videos.each do |item|
        item.save
      end

    end
  end
end