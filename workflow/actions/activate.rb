#
# This file originally written by Clinton Strong for the Search Safari and Chrome Tabs Workflow
# published at http://www.alfredforum.com/topic/236-search-safari-and-chrome-tabs-updated-feb-8-2014/?hl=%2Bsafari+%2Btabs
# This workflow has been forked from the Feb 8, 2014 release of the workflow and is currently in a modified state.
#

Encoding.default_external = Encoding::UTF_8 if defined? Encoding

require File.expand_path('../../browser_tabs', __FILE__)

url = ARGV[0]

if url =~ /^'(.*)'[,]*\s'(.*)'$/
if $2 == "open"
url = $1
exec( 'open "' + $1 + '"' )
end
else
BrowserTabs.activate(url)
end
