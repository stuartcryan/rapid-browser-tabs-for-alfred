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