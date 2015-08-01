#
# This file originally written by Clinton Strong for the Search Safari and Chrome Tabs Workflow
# published at http://www.alfredforum.com/topic/236-search-safari-and-chrome-tabs-updated-feb-8-2014/?hl=%2Bsafari+%2Btabs
# This file has been forked from the Feb 8, 2014 release of the workflow and is currently in an unmodified state
# with the exception of this comment)
#

require 'browser_tabs/applescript_utils'

module BrowserTabs
  class Command
    attr_reader :running_browsers

    # AppleScript code to run at the beginning of the script
    def prefix
      nil
    end

    # AppleScript code to run at the end of the script. The output will be passed
    # as a string to #result.
    def suffix
      nil
    end

    def before_browser
      nil
    end

    def after_browser
      nil
    end

    def browser_body
      nil
    end

    # The return value when you #run a command. `output` is generally a string
    # value representing the result of the last expression run in #suffix.
    def result(output)
      output
    end

    def run(opts)
      code = generate(opts)

      # No need to run the code if no browsers are running
      return false unless running_browsers

      output = AppleScriptUtils.run(code)
      result(output)
    end

    def generate(opts)
      setup(opts)
      construct_applescript
    end

    def setup(opts)
      @running_browsers = opts[:running_browsers] || []
    end

    private

    def construct_applescript
      script = "#{prefix}\n"

      running_browsers.each do |app_name|
        @app_name = app_name
        script << construct_applescript_for_browser(app_name) << "\n\n"
      end

      script << suffix.to_s
    end

    def construct_applescript_for_browser(app_name)
      <<-APPLESCRIPT
        #{before_browser}

        tell application "#{app_name}"
          #{browser_body}
        end tell

        #{after_browser}
      APPLESCRIPT
    end
  end
end
