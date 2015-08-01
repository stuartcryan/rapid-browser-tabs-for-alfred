require 'browser_tabs/commands/command'

module BrowserTabs
  class TabCommand < Command
    # AppleScript expression to determine if #body should be executed for a tab.
    def tab_condition
      nil
    end

    # AppleScript code to be run for each tab. If #condition is overridden, this
    # will be enclosed in an if block, otherwise it'll always run.
    def tab_body
      nil
    end

    def browser_body        
      <<-APPLESCRIPT
        set _window_index to 1

        repeat with _window in windows
          try
            set _tab_count to (count of tabs in _window)
            set _tab_index to 1
            repeat with _tab in tabs of _window
              #{tab_body_with_condition}

              set _tab_index to _tab_index + 1
            end repeat
          end try
          set _window_index to _window_index + 1
        end repeat
      APPLESCRIPT
    end

    private

    def tab_body_with_condition
      return tab_body unless tab_condition

      <<-APPLESCRIPT
        if (#{tab_condition}) then
          #{tab_body}
        end if
      APPLESCRIPT
    end

    def extract_url(url_or_tab)
      url_or_tab.respond_to?(:url) ? url_or_tab.url : url_or_tab
    end
  end
end
