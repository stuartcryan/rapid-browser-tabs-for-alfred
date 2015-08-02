#
# This file originally written by Clinton Strong for the Search Safari and Chrome Tabs Workflow
# published at http://www.alfredforum.com/topic/236-search-safari-and-chrome-tabs-updated-feb-8-2014/?hl=%2Bsafari+%2Btabs
# This file has been forked from the Feb 8, 2014 release of the workflow and is currently in an unmodified state
# with the exception of this comment)
#

module BrowserTabs
  module AppleScriptUtils
    class AppleScriptError < StandardError; end
    
    class << self
      def run_file(filename, *args)
        osascript(true, *args)
      end

      def run(src, *args)
        osascript(false, src, *args)
      end

      def escape_str(str)
        str.gsub("\\", "\\\\\\").gsub('"', '\\\\"')
      end

      private

      def osascript(is_file, *args)
        require 'open3'

        src = args.shift unless is_file

        Open3.popen3('osascript', *args) do |stdin, stdout, stderr|
          stdin.write(src) unless is_file
          stdin.close
          
          err_msg = stderr.read.chomp
          raise AppleScriptError, "AppleScript error: #{err_msg}" unless err_msg.empty?
          
          stdout.read.chomp
        end
      end
    end
  end
end
