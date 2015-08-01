#
# This file originally written by Clinton Strong for the Search Safari and Chrome Tabs Workflow
# published at http://www.alfredforum.com/topic/236-search-safari-and-chrome-tabs-updated-feb-8-2014/?hl=%2Bsafari+%2Btabs
# This file has been forked from the Feb 8, 2014 release of the workflow and is currently in an unmodified state
# with the exception of this comment)
#

require 'browser_tabs/commands/tab_command'

module BrowserTabs
  class UrlCommand < TabCommand
    def tab_condition
      %Q(url of _tab as string is "#{AppleScriptUtils.escape_str(@url)}")
    end
    
    def extract_url(url_or_tab)
      url_or_tab.respond_to?(:url) ? url_or_tab.url : url_or_tab
    end

    def setup(opts)
      super
      @url = extract_url(opts[:url])
    end  
  end
end
