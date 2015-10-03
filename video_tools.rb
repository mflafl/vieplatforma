
require 'streamio-ffmpeg'

class VideoTools

  def self.get_movie(source_file)
    movie = FFMPEG::Movie.new(source_file)
    if !self.valid_movie? movie
      throw "Movie is invalid"
    end
    movie
  end

  def self.valid_movie?(movie)
    movie.valid?
  end

  def self.get_seconds_from_start(time_string)
    time_pieces = time_string.split(":").map {|i| i.to_i}
    time_pieces[0] * 3600 + time_pieces[1] * 60 + time_pieces[2]
  end

  def self.get_fragment_duration(movie, start_time, end_time)
    start_seconds = self.get_seconds_from_start(start_time)
    end_seconds = self.get_seconds_from_start(end_time)

    if start_seconds >= end_seconds
      throw "Bad video fragment time params"
    end

    duration = end_seconds - start_seconds

    if start_seconds + duration > movie.duration
      throw "Movie is too short to take required fragment"
    end

    duration
  end

  def self.get_fragment(source_file, start_time, end_time)
    movie = self.get_movie(source_file)
    duration = VideoTools.get_fragment_duration(movie, start_time, end_time)
    start_seconds = VideoTools.get_seconds_from_start(start_time)

    basename = File.basename(source_file, ".*")
    extension = File.extname(source_file)

    output_file_time_caption = start_time.dup.gsub!(":", "") + '-' + end_time.dup.gsub!(":", "")

    output_filename = sprintf "%<basename>s-%<time>s%<extension>s",
                          {:basename => basename, :time => output_file_time_caption, :extension => extension}

    exec sprintf "ffmpeg -ss %<start>s -i %<input>s -strict -2 -t %<duration>d -c copy '%<output>s'",
                 { :start => start_seconds, :duration => duration, :input => source_file, :output => output_filename }
  end

  def self.extract(source_file)
    movie = self.get_movie(source_file)
    exec sprintf "cvlc %<source_file>s --rate=1 --video-filter=scene --vout=dummy --start-time=0 --scene-ratio 1 --scene-format=png --scene-prefix=snap  --scene-path=%<output_dir>s vlc://quit",
        {:output_dir => "test", :source_file => source_file}
  end

end