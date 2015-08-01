#
# This file originally written by Clinton Strong for the Search Safari and Chrome Tabs Workflow
# published at http://www.alfredforum.com/topic/236-search-safari-and-chrome-tabs-updated-feb-8-2014/?hl=%2Bsafari+%2Btabs
# This file has been forked from the Feb 8, 2014 release of the workflow and is currently in an unmodified state
# with the exception of this comment)
#

require 'browser_tabs/commands/url_command'

module BrowserTabs
  class CloseTab < UrlCommand
    def tab_body
      "activate\nclose _tab\nexit repeat"
    end
  end
end
