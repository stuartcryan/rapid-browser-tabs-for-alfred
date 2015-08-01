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