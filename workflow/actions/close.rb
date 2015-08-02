#
# This file originally written by Clinton Strong for the Search Safari and Chrome Tabs Workflow
# published at http://www.alfredforum.com/topic/236-search-safari-and-chrome-tabs-updated-feb-8-2014/?hl=%2Bsafari+%2Btabs
# This file has been forked from the Feb 8, 2014 release of the workflow and is currently in an unmodified state
# with the exception of this comment)
#

Encoding.default_external = Encoding::UTF_8 if defined? Encoding

require File.expand_path('../../browser_tabs', __FILE__)

url = ARGV[0]

BrowserTabs.close(url)
