#
# This file originally written by Clinton Strong for the Search Safari and Chrome Tabs Workflow
# published at http://www.alfredforum.com/topic/236-search-safari-and-chrome-tabs-updated-feb-8-2014/?hl=%2Bsafari+%2Btabs
# This file has been forked from the Feb 8, 2014 release of the workflow and is currently in an unmodified state
# with the exception of this comment)
#

module BrowserTabs
  class Tab
    attr_reader :browser, :window, :index, :url, :title, :domain

    def initialize(opts)
      @browser = opts[:browser]
      @window  = opts[:window]
      @index   = opts[:index]
      @url     = opts[:url]
      @title   = opts[:title]
      @domain  = parse_domain
    end

    def close
      BrowserTabs.close(self)
    end

    def activate
      BrowserTabs.activate(self)
    end

    private

    def parse_domain
      components = url.split('/')

      # Return an empty string if we have a file url or a url like topsites://
      return '' if components.length < 3 || components[2] == ''

      # Strip the port so we just have the domain
      components[2].split(':').first
    end
  end
end
