Encoding.default_external = Encoding::UTF_8 if defined? Encoding

require 'yaml'
require 'fileutils'

require File.expand_path('../alfred_feedback', __FILE__)
require File.expand_path('../browser_tabs', __FILE__)

#global_config_file="config/setup.yml"
#until we know otherwise force config location (make sure this always has a trailing slash... we assume it will)
default_config_location="~/Library/Application Support/Alfred 2/Workflow Data/com.stuartryan.alfred.rapidbrowsertabs/"
example_sites_config="config/sites_example.yml"
example_setup_config="config/setup_example.yml"
setup_file_name="setup.yml"
sites_file_name="sites.yml"

query = ARGV[0].strip.downcase
tabs = BrowserTabs.tabs
fb = Feedback.new

def copy_with_path(src, dst)
  FileUtils.mkdir_p(File.dirname(dst))
  FileUtils.cp(src, dst)
end

if !File.file?(File.expand_path(default_config_location + setup_file_name)) 
setup_config_destination = File.expand_path(default_config_location + setup_file_name)
sites_config_destination = File.expand_path(default_config_location + sites_file_name)
copy_with_path(example_setup_config, setup_config_destination)
copy_with_path(example_sites_config, sites_config_destination)
else
global_config = begin
  YAML.load(File.open(File.expand_path(default_config_location + setup_file_name)))
rescue ArgumentError => e
  puts "Could not parse YAML: #{e.message}"
end

default_config_location=global_config['config_location']

end

# Search anchored to slashes, dashes, and underscores
def tab_matches_url?(tab, q)
  q1 = Regexp.escape(q)
  search_regexp = /[\/_-]+.*#{Regexp.escape(q)}/
  (tab.url =~ search_regexp)  != nil
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

parsed = begin
  YAML.load(File.open(File.expand_path(default_config_location + sites_file_name)))
rescue ArgumentError => e
  puts "Could not parse YAML: #{e.message}"
end

known_tabs ||= []

if query != ""
	tab_count = 0
	global_key = ""
	global_url = ""
	global_icon_location = ""
	parsed.each do |key, value|
		url = ""
		icon = ""
		@aliases = Array.new
		aliases = ""
		value.each do |k,v|
    		if k == "url"
    			url = v
    		elsif k == "aliases"
    			v.slice!(0)
    			@aliases.push(words = v.split(' -'))
    			aliases = v
			elsif k == "icon"
   				icon = v
		    end
  		end
  		if key.downcase.include?(query) || aliases.downcase.include?(query)
  		#query is a heavily modified version of @giegoperini's example from https://mathiasbynens.be/demo/url-regex modified to work with Ruby
  		url =~ /^^(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!10(?:\.\d{1,3}){3})(?!127(?:\.\d{1,3}){3})(?!169\.254(?:\.\d{1,3}){2})(?!192\.168(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|((?:(?:[a-z\\x{00a1}\-\\x{ffff}0-9]+\-?)*[a-z\\x{00a1}\-\\x{ffff}0-9]+)(?:\.(?:[a-z\\x{00a1}\-\\x{ffff}0-9]+\-?)*[a-z\\x{00a1}\-\\x{ffff}0-9]+)*(?:\.(?:[a-z\\x{00a1}\-\\x{ffff}]{2,}))|(?:([0-9]*\.[0-9]*.[0-9]*.[0-9]*))?)((?::\d{2,5})?(?:\/*[^\s]*)))?$/
  		stripped_url = $1
  		#$3 contains the URI - strip out the first folder if any
  		$3 =~ /((?::[0-9]*)?)((?:\/[^\/]*)?)((?:\/.*))?/
  		#$1 will contain port number if any
  		#$2 will contain first folder if any
  		#$3 will contain remainder of URI if any
  		if defined?($1) && defined?($2)
  		stripped_url = stripped_url  + $1 + $2
  		elsif defined?($1) && !defined?($2)
  		stripped_url = stripped_url  + $1
  		elsif !defined?($1) && defined?($2)
  		stripped_url = stripped_url  + $2
  		else
  		stripped_url = stripped_url
  		end
  		
  			tabs.each do |tab|
  				next unless tab_matches_query?(tab, stripped_url)
  				if !known_tabs.include? (tab.browser + ":" + tab.window.to_s + ":" + tab.index.to_s)
  				tab_count += 1
  				known_tabs.push(tab.browser + ":" + tab.window.to_s + ":" + tab.index.to_s)
  				fb.add_item(
    			:title => tab.title,
   				:subtitle => tab.url,
    			:uid => tab.url,
    			:arg => tab.url,
    			:icon => { :name => icon_for_tab(tab) })
    			end
			end

  			tabs.each do |tab|
  				next unless tab_matches_query?(tab, query)
  				if !known_tabs.include? tab.browser + ":" + tab.window.to_s + ":" + tab.index.to_s
  				known_tabs.push(tab.browser + ":" + tab.window.to_s + ":" + tab.index.to_s)
  				tab_count += 1
  				fb.add_item(
    			:title => tab.title,
   				:subtitle => tab.url,
    			:uid => tab.url,
    			:arg => tab.url,
    			:icon => { :name => icon_for_tab(tab) })
    			end
			end
			
  			if icon == ""
  				icon_location="icon.png"
  			else 
  				icon_location=default_config_location + "icons/" + icon
  			end
  			global_key = key
  			global_url = url
  			global_icon_location = icon_location
			if tab_count != 0
			  	fb.add_item(
    			:title => key,
   				:subtitle => "Open a new instance of " + key + ".",
    			:uid => url + "new",
    			:arg => "'" + url + "', 'open'",
    			:icon => { :name => icon_location })
    		end
		end
			if tab_count == 0 && (key.downcase.include?(query) || aliases.downcase.include?(query))
			    tab_count += 1
				fb.add_item(
    			:title => global_key,
   				:subtitle => "Open a new instance of " + global_key + ".",
    			:uid => global_url,
    			:arg => "'" + global_url + "', 'open'",
    			:icon => { :name => global_icon_location })
    		end

	end
	
	if tab_count == 0
		if global_key == ""
			result_count = 0
			tabs.each do |tab|
  				next unless tab_matches_query?(tab, query)
				
				result_count += 1
  				fb.add_item(
    			:title => tab.title,
    			:subtitle => tab.url,
    			:uid => tab.url,
    			:arg => tab.url,
    			:icon => { :name => icon_for_tab(tab) })
			end
			if result_count == 0
				fb.add_item(
    			:title => "No such tab found...",
    			:subtitle => "Sorry :(",
    			:icon => { :name => "error.png" })
			end
			puts fb.to_xml
		else
			fb.add_item(
    		:title => global_key,
   			:subtitle => global_key + " is not currently open. Press enter to open a new instance.",
    		:uid => global_url,
    		:arg => "'" + global_url + "', 'open'",
    		:icon => { :name => global_icon_location })
    	end
    end
puts fb.to_xml
else
	tab_count = 0
	global_key = ""
	global_url = ""
	global_icon_location = ""
	parsed.each do |key, value|
		url = ""
		icon = ""
		@aliases = Array.new
		aliases = ""
		value.each do |k,v|
    		if k == "url"
    			url = v
    		elsif k == "aliases"
    			v.slice!(0)
    			@aliases.push(words = v.split(' -'))
    			aliases = v
			elsif k == "icon"
   				icon = v
		    end
  		end
  		if icon == ""
  			icon_location="icon.png"
  		else 
  			icon_location=default_config_location + "icons/" + icon
  		end
		tab_count += 1
		fb.add_item(
    	:title => key,
   		:subtitle => "Open a new instance of " + key + ".",
    	:uid => url,
    	:arg => "'" + url + "', 'open'",
    	:icon => { :name => icon_location })
	end
puts fb.to_xml
end
