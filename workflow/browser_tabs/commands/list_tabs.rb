require 'browser_tabs/commands/tab_command'

module BrowserTabs
  class ListTabs < TabCommand
    def prefix
      'set _output to ""'
    end

    def suffix
      '_output'
    end

    def activate?
      false
    end

    def tab_body
      if @app_name == 'Safari' || @app_name == 'WebKit'
        title_keyword = 'name'
      else
        title_keyword = 'title'
      end

      %Q{set _output to _output & "#{@app_name}:" &} <<
      %Q{(_window_index as string) & ":" & (_tab_index as string) & "\n" & } <<
      %Q{url of _tab & "\n" & #{title_keyword} of _tab & "\n"}
    end

    def result(output)
      parse_tab_data(output)
    end

    def parse_tab_data(tab_data)
      tab_list = []

      tab_data.split("\n").each_slice(3) do |lines|
        next if lines.length < 3
        lines.map!(&:strip)

        app_name, window_index, tab_index = lines[0].split(":")

        window_index = window_index.to_i
        tab_index    = tab_index.to_i

        url = lines[1]
        title = lines[2]

        tab_list << Tab.new(
          :browser => app_name,
          :window => window_index - 1,
          :index => tab_index - 1,
          :url => url,
          :title => title
        )
      end

      tab_list
    end
  end
end
