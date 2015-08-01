Encoding.default_external = Encoding::UTF_8 if defined? Encoding

require File.expand_path('../alfred_feedback', __FILE__)
require File.expand_path('../browser_tabs', __FILE__)

query = ARGV[0].strip.downcase
tabs = BrowserTabs.tabs
fb = Feedback.new

# Search anchored to slashes, dashes, and underscores
def tab_matches_url?(tab, q)
  search_regexp = /[\/_-]+#{Regexp.escape(q)}/

  (tab.url =~ search_regexp) != nil
end

# Search anchored to the start of words (including CamelCase)
def tab_matches_title?(tab, q)
  search_regexp = /(\b|[\/\._-])#{Regexp.escape(q)}/

  tab.title.downcase =~ search_regexp ||
  # Break CamelCase words into their individual components and search
  tab.title.gsub(/([a-z\d])([A-Z])/,'\1 \2').downcase =~ search_regexp
end

def tab_matches_query?(tab, q)
  tab_matches_url?(tab, q) || tab_matches_title?(tab, q)
end

def icon_for_tab(tab)
  if tab.browser == "WebKit" || tab.browser == "Safari"
    "/Applications/Safari.app/Contents/Resources/document.icns"
  else
    "/Applications/#{tab.browser}.app/Contents/Resources/document.icns"
  end
end

tabs.each do |tab|
  next unless tab_matches_query?(tab, query)

  fb.add_item(
    :title => tab.title,
    :subtitle => tab.url,
    :uid => tab.url,
    :arg => tab.url,
    :icon => { :name => icon_for_tab(tab) })
end

puts fb.to_xml
