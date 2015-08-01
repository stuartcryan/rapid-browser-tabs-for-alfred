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
