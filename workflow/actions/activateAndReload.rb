Encoding.default_external = Encoding::UTF_8 if defined? Encoding

require File.expand_path('../../browser_tabs', __FILE__)

url = ARGV[0]

if url =~ /^'(.*)'[,]*\s'(.*)'$/
if $2 == "open"
url = $1
exec( 'open "' + $1 + '"' )
end
else
BrowserTabs.activateAndReload(url)
end
