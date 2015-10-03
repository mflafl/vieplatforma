
require 'thor'
require_relative 'video_tools'

class ExtractVideo < Thor
  desc "fragment source --start 00:00:00 --stop 00:00:10", "Extract a fragment from video"
  option :start
  option :end

  def fragment(source_file)
    VideoTools.get_fragment source_file, options[:start], options[:end]
  end

  desc "extract source", "Extract all frames from video"
  def extract(source_file)
    VideoTools.extract source_file
  end

end

ExtractVideo.start(ARGV)