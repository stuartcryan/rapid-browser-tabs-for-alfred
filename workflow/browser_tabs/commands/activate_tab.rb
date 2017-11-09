#
# This file originally written by Clinton Strong for the Search Safari and Chrome Tabs Workflow
# published at http://www.alfredforum.com/topic/236-search-safari-and-chrome-tabs-updated-feb-8-2014/?hl=%2Bsafari+%2Btabs
# This file has been forked from the Feb 8, 2014 release of the workflow and is currently in an unmodified state
# with the exception of this comment)
#

require 'browser_tabs/commands/url_command'

module BrowserTabs
  class ActivateTab < UrlCommand
    def prefix
      "set _tab_was_found to false"
    end

    def tab_body
      if @app_name == 'Safari' || @app_name == 'Safari Technology Preview' || @app_name == 'WebKit'
        active_tab_keyword = 'current tab to tab'
      else
        active_tab_keyword = 'active tab index to '
      end

      <<-APPLESCRIPT
        set _tab_was_found to true
        activate
        tell _window
          set #{active_tab_keyword} _tab_index
          set index to 1
        end tell
        exit repeat
      APPLESCRIPT
    end

    def after_browser
      <<-APPLESCRIPT
        if (_tab_was_found) then
          -- Bring window to front
          tell application "System Events" to tell process "#{@app_name}"
            perform action "AXRaise" of window 1
            -- account for instances when the window doesn't switch fast enough
            delay 0.5
            perform action "AXRaise" of window 1
            -- Prevent other running browsers from potentially activating
            return
          end tell
        end if
      APPLESCRIPT
    end
  end
end
