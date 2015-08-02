#
# This file originally written by Clinton Strong for the Search Safari and Chrome Tabs Workflow
# published at http://www.alfredforum.com/topic/236-search-safari-and-chrome-tabs-updated-feb-8-2014/?hl=%2Bsafari+%2Btabs
# This file has been forked from the Feb 8, 2014 release of the workflow and is currently in an unmodified state
# with the exception of this comment)
#

module BrowserTabs
  class Processes
    attr_accessor :ps

    def app_running?(app_name)
      ps.include?(process_name(app_name))
    end

    def ps
      @ps || retrieve_processes
    end

    # Refresh list of processes
    def ps!
      retrieve_processes
    end

    private

    def retrieve_processes
      @ps = `ps ax`
    end

    def process_name(app_name)
      if app_name == 'WebKit'
        "Safari.app/Contents/MacOS/SafariForWebKitDevelopment"
      else
        "#{app_name}.app/Contents/MacOS/#{app_name}"
      end
    end
  end
end
