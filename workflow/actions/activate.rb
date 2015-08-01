Encoding.default_external = Encoding::UTF_8 if defined? Encoding

require File.expand_path('../../browser_tabs', __FILE__)

url = ARGV[0]

BrowserTabs.activate(url)
