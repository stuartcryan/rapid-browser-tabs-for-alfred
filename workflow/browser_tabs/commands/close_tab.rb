require 'browser_tabs/commands/url_command'

module BrowserTabs
  class CloseTab < UrlCommand
    def tab_body
      "activate\nclose _tab\nexit repeat"
    end
  end
end
