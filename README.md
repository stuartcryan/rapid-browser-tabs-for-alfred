# Search, activate, reload and close your active Chrome and Safari tabs and favourite sites.
RBT allows you to do the following all from within Alfred:

1. Search all open tabs across Chrome and Safari and load a selected tab.
2. Reload a tab forcibly when you select it if you want.
3. Add "favourite" sites to the workflow for quick access with defined keywords. 
4. Synchronise your favourites across computers.  

RBT for Alfred has been forked from the Search Tabs on Safari and Chrome workflow developed by Clinton Strong (with Clinton's blessing) and could almost be considered v2 of Clinton's original workflow.

## Donations
This workflow represents many many hours effort of development, testing and rework. The images licensed for this workflow from [DepositPhotos](http://depositphotos.com?ref=1682540) also needed a bit of my moolah. So if you love the workflow, and get use out of it every day, if you would like to donate as a thank you to buy me more caffeine giving Diet Coke, some Cake, or to put towards a shiny new gadget you can [donate to me via Paypal](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=JM6E65M2GLXHE). 

<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=JM6E65M2GLXHE" target="_blank"><img src="https://www.paypalobjects.com/en_AU/i/btn/btn_donateCC_LG.gif" border="0" alt="PayPal — The safer, easier way to pay online."></a>


## Installation

1. Download the .alfredworkflow file
2. Run to import into Alfred

## Setup
Before you can do anything with the workflow you will need to initialise the settings:

1. Run rbtsetup and select 'Initialise Workflow Configuration'
2. The workflow will then copy over the default configuration files and example icons.

<img src="http://akamai.technicalnotebook.com/alfred-workflow-images/rapid-browser-tabs-for-alfred/pre_config.png">

The workflow has been designed to enable settings synchronisation via a mechanism of your choice (such as Dropbox). It is easiest to set this up before you get too deep into configuring the workflow.

To configure synchronisation via Dropbox (as an example):

1. Run 'rbtsetup' and select "Set root config folder location"
2. Update the folder name to point to a new location, my personal preference is "~/Dropbox/AlfredSync/Workflow Data/com.stuartryan.alfred.rapidbrowsertabs/" (however you can use any location as long as you set it to be the same on different computers)
3. Ensure you have ended your path with a trailing forward slash (things will break if you don't) and then save and close the configuration file. 
4. If this is the first computer you are setting the workflow up on (i.e. that directory does not exist or is empty) run rbtsetup then select "Refresh workflow configuration" to copy the default configurations into place
5. Repeat steps 1 to 3 for every subsequent computer you will run the workflow on (after the initial sync has completed via Dropbox).

<img src="http://akamai.technicalnotebook.com/alfred-workflow-images/rapid-browser-tabs-for-alfred/configure_screen.png">

Configure a hotkey:
To make your life easier I also recommend you set up a hotkey for use with the workflow. 

1. Open Alfred
2. Click Workflows --> Rapid Browser Tabs
3. Double click on the Hotkey box
4. Enter your hotkey and ensure the action is set to "Pass through to workflow"
5. The argument should be set to "None"
6. Click Save

## Basic Usage

The default keyword set is "rbt" here are some examples of what you can do:
* rbt google - Will show all tabs you currently have open that have google in the URL or the tab description.
* rbt fb - FB is set as a keyword for Facebook. This will show any current Facebook tabs already open and will also allow you to open a new Facebook tab in your default browser as well.
* rbt nf - Same thing as above but will open Netflix
* rbt netflix - Same as above, workflow will recognise this is a favourite site and show all tabs currently open and will also offer the option to open a new tab to the Netflix website.
* ctrl key modifier - The control key when held down while selecting a tab will force the tab to reload/refresh when it is opened

For backwards compatibility with the human brain (and the fact that everyone is used to using the keyword "tabs"), an additional entry point into the workflow using the keyword "tabs" has been added. Depending on user feedback this may be removed or adopted permanently in the future.

<img src="http://akamai.technicalnotebook.com/alfred-workflow-images/rapid-browser-tabs-for-alfred/facebook_example.png">

<img src="http://akamai.technicalnotebook.com/alfred-workflow-images/rapid-browser-tabs-for-alfred/favourites_example.png">

## Advanced Configuration - Adding your own favourites

### YAML Config File
Once you have the hang of the basic usage of the workflow, you can get down to configuring extra "Favourites".

The favourites have been designed to represent the most used sites you use, the ones that you access day in and day out so that you can get rapid access to them.

I have found after setting these up originally I have only added to the list a couple of times as it is expected the list will become relatively static after the first couple of weeks usage.

To access the sites configuration:
* Run rbtsetup then select "Modify Sites Configuration"
* The default configuration example has examples that you can copy and modify to add your own favourites

The two basic styles of configuration are:
First Example:
```YAML
YouTube: 
  aliases: "-yt"
  icon: youtube.png
  url: "https://www.youtube.com"
```
Second Example:

```YAML
? "YouTube Video Manager"
: 
  aliases: "-yta -ytvm -youtube admin"
  icon: youtubeadmin.png
  url: "https://www.youtube.com/my_videos"
```
The key difference between the two above examples are the use of the '? "Site name"' in the second example. When the site name has spaces, you should copy the second example. You can however always opt to use this format regardless of whether the site name has spaces or not if you want to go the easy route.

The aliases section can list zero or more aliases (for zero just use "", and do not delete the line). Each alias should be prefixed by a dash '-', and you can have as many keywords as you would like (but remember... less is more).

If you are having problems with the site configuration you have created, a great first point is to run it through [YAML Lint](http://www.yamllint.com/) which can validate if there is anything invalid in your syntax. If that comes back clean and you still have issues please log an issue.

### Adding the pretty favourite images

You will notice in the above example each item references a png icon file. You can save icons that you would like to represent your favourites in the icons folder. This is accessed by typing 'rbtsetup' then selecting "Open icons storage folder". As long as the icons in this folder match what you put on your text you can use a pretty icon.

If you would rather not use an image just use 'icon.png' and this will use the default icon for the workflow.

## Supported Browsers

Currently the workflow supports the following browsers. As Firefox does not expose its tabs via Applescript, it is not able to be supported. If someone is a whizz at writing Firefox plugins and would like to collaborate on a plugin to get this to work please feel free to get into contact with me.
* Chrome
* Safari
* Safari Technology Preview
* Chromium
* Chrome Canary
* Webkit

## Contributing

If you are a coder:

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

If you aren't a coder:

Feel free to [log your ideas and suggestions on GitHub](https://github.com/stuartcryan/rapid-browser-tabs-for-alfred/issues) and I will see what I can do. 

## History

* Version 1.1 - Bugfix and Feature Release
	* Fix - Tab icon for Safari did not display
	* Feature - Add "ctrl" key modifier to force reload tab on opening
	* Feature - Provide feedback on settings initialisation and sync
	* Feature - Enable favourite searching by URL
* Version 1.0 - Initial Release of Rapid Browser Tabs for Alfred
* Version 0.9 - Forked from Search Safari and Chrome Tabs workflow Feb 2014 release

## Credits

Rapid Browser Tabs for Alfred workflow created by [Stuart Ryan](http://stuartryan.com). If you would like to get into contact you can do so via:
* [@StuartCRyan on Twitter](http://twitter.com/stuartcryan)
* [Stuart Ryan on LinkedIn](https://au.linkedin.com/in/stuartcryan)
* [Technical Notebook Blog](http://technicalnotebook.com)

[Search Tabs on Safari and Chrome workflow](http://www.alfredforum.com/topic/236-search-safari-and-chrome-tabs-updated-feb-8-2014/) created by Clinton Strong represented the initial stages for this workflow.
* Clinton has been kind enough to provide his blessing for the code to be forked and maintained as a new workflow.
* Any future code releases to the Search Tabs on Safari and Chrome workflow may be merged into this workflow if required (and as long as the original licensing permits).

## License

All *code* in this workflow is released under the MIT License. Images used as part of the workflow are licensed only for use in this workflow and must be changed if the workflow is forked in the future.

All images have been licensed from [DepositPhotos](http://depositphotos.com?ref=1682540) to Stuart Ryan.