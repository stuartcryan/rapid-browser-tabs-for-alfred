# Allow for local testing without having the gem installed
$:.unshift File.dirname(__FILE__)

require 'browser_tabs/version'
require 'browser_tabs/tab'
require 'browser_tabs/processes'
require 'browser_tabs/commands/list_tabs'
require 'browser_tabs/commands/close_tab'
require 'browser_tabs/commands/activate_tab'

module BrowserTabs
  class << self
    def supported_browsers
      @supported_browsers ||= [
        'Safari',
        'WebKit',
        'Google Chrome',
        'Google Chrome Canary',
        'Chromium'
      ]
    end

    def tabs
      run_command(@tab_lister ||= ListTabs.new)
    end

    alias_method :list, :tabs

    def close(url)
      run_command(@tab_closer ||= CloseTab.new, :url => url)
    end

    def activate(url)
      run_command(@tab_activator ||= ActivateTab.new, :url => url)
    end

    def browser_running?(app_name)
      processes.app_running?(app_name)
    end

    def running_browsers
      @running_browsers ||= supported_browsers.select do |app|
        browser_running?(app)
      end
    end

    private

    def run_command(command, opts = {})
      refresh_processes
      command.run({:running_browsers => running_browsers}.merge(opts))
    end

    def processes
      @processes || refresh_processes
    end

    def refresh_processes
      @running_browsers = nil
      @processes = Processes.new
    end
  end
end
