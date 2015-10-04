
require 'thor'
require_relative 'video_tools'

class VideoToolsCLI < Thor
  desc "fragment source --start 00:00:00 --stop 00:00:10", "Extract video fragment"
  option :start
  option :end

  def fragment(source_file)
    VideoTools.get_fragment source_file, options[:start], options[:end]
  end

  desc "extract source", "Extract all video frames"

  def extract(source_file)
    VideoTools.extract source_file
  end

end

VideoToolsCLI.start(ARGV)