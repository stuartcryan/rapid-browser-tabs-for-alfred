Encoding.default_external = Encoding::UTF_8 if defined? Encoding

require 'yaml'
require 'fileutils'

require File.expand_path('../alfred_feedback', __FILE__)

#global_config_file="config/setup.yml"
#until we know otherwise force config location (make sure this always has a trailing slash... we assume it will)
default_config_location="~/Library/Application Support/Alfred 2/Workflow Data/com.stuartryan.alfred.rapidbrowsertabs/"
original_default_config_location=default_config_location
example_sites_config="config/sites_example.yml"
example_setup_config="config/setup_example.yml"
example_icon_folder="config/icons_example"
icon_folder="icons"
setup_file_name="setup.yml"
sites_file_name="sites.yml"
icon_directory_name="icons"
standard_default_config_location=default_config_location + setup_file_name

query = ARGV[0].strip.downcase
fb = Feedback.new

def copy_with_path(src, dst)
  FileUtils.mkdir_p(File.dirname(dst))
  FileUtils.cp(src, dst)
end

def copy_directory(src, dst)
  FileUtils.cp_r(src, dst)
end

if !File.file?(File.expand_path(default_config_location + setup_file_name)) 
	setup_config_destination = File.expand_path(default_config_location + setup_file_name)
	sites_config_destination = File.expand_path(default_config_location + sites_file_name)
	copy_with_path(example_setup_config, setup_config_destination)
	copy_with_path(example_sites_config, sites_config_destination)
	if !Dir.exists?(File.expand_path(default_config_location + icon_directory_name)) 
		copy_directory(File.expand_path(example_icon_folder), File.expand_path(default_config_location + icon_folder))
	end
else
	global_config = begin
	YAML.load(File.open(File.expand_path(default_config_location + setup_file_name)))
	rescue ArgumentError => e
	puts "Could not parse YAML: #{e.message}"
	end

default_config_location=global_config['config_location']

end

if query == "sitesconfig"
	system "open '" + File.expand_path(default_config_location + sites_file_name) + "'"
	puts "Sites configuration file opened"
elsif query == "configfolder"
	system "open '" + File.expand_path(default_config_location) + "'"
	puts "Configuration folder opened"
elsif query == "configfolderlocationsetup"
	system "open '" + File.expand_path(standard_default_config_location) + "'"
	puts "Config location config file opened"
elsif query == "iconsfolder"
	system "open '" + File.expand_path(standard_default_config_location + icon_folder) + "'"
	puts "Icons folder opened"
elsif query == "refreshconfig"
#	if (!Dir.exists?(File.expand_path(default_config_location)))
#		FileUtils.mkdir_p(File.expand_path(default_config_location))
#	end
		
	if (default_config_location == original_default_config_location)
		#if default config location is equal to original config location AND setup file name does not exist - copy it
		if !File.file?(File.expand_path(default_config_location + sites_file_name))
			copy_with_path(example_sites_config, File.expand_path(default_config_location + sites_file_name))
		end
		#if default config location is equal to original config location AND images directory does not exist - copy it
		if !Dir.exists?(File.expand_path(default_config_location + icon_directory_name)) 
			copy_directory(File.expand_path(example_icon_folder), File.expand_path(default_config_location + icon_folder))
		end
		puts "Copied default configuration"
	end

	if (default_config_location != original_default_config_location)
		#if default config location is not original default config location AND sites.conf does not exist copy it from original default config location
		if (!File.file?(File.expand_path(default_config_location + sites_file_name)))
			#copy from original_default_config_location to new default_config_location
			copy_with_path(File.expand_path(original_default_config_location + sites_file_name), File.expand_path(default_config_location + sites_file_name))
		end

		#if default config location is not original default config location AND images folder does not exist copy it from original default config location
		if (!Dir.exists?(File.expand_path(default_config_location + icon_directory_name)))
			copy_directory(File.expand_path(original_default_config_location + icon_folder), File.expand_path(default_config_location))
		end
		puts "Copied/Refreshed configuration files"
	end
end
