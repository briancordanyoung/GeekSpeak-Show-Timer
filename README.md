# GeekSpeak-Show-Timer

During the recording of GeekSpeak, we need to plan for an inexactly placed break and a precise show length.  This is the timer we use to make that as easy as possible.


Updated to KBCZ 2 section 59 minute timer
=============================
2 equal sections at 29.5 mintes each.

=======


## Todo:

- Create About viewController to explain
	- what GeepSeak is
	- who I am
	- request feedback about developing the app into a genera purpose timer
- Create graphics for Add & Remove seconds buttons.
- Add socket connection to GeekSpeak.org API
	- use site for syncing concurrent timers
	- keep histery of past timers
	- sync pending bits to a table view
	- tapping on a bit marks the time and posts to site
- Add tracking of all pause/play events
	
- Add GameKit discovery and networking between timers on multiple devices
- Layout issues
	- Fix labels under show times to scale based on text width
- Abstract out the hard coded definition of 3 segments with one minute breaks, into a definition file. Auto generate views based on this definition, allowing multiple show formats

## Versions:
# v0.1
_(this version is tagged but, the tag isn't showing up in github for some reason)_

This is the initial version of the timer and used on the 8/3/15 recording of the show (aired 8/8/15).  It is useable, but truely a beta release.  Many views don't have any layout code and you can get the app in an unusable state on iPhones. [Here is a video demo of this version](https://www.youtube.com/watch?v=kwDyj1H7LJw)


## Architecture choices:
# Sharing Timer object between multiple view controllers
- Using the SplitViewController or App Delegate as a central place to create a Timer property that the viewControllers can look it up from
	- Easy
	- Tightly Coupled.  The ViewControllers need to know about where to find the Time property
	- Limits app to using a single Timer
		- What if I want to save past Timers and use the same view controller to display it again?
- Create a singlton to vend a Timer to the viewControllers
	- Only slightly less coupled than above.  Has all the same problems, only without needing to know where to find the property
- Don't lookup the Timer, but instead use the Notification Center to subscribe to and use the Notification object.
	- Incomplete:
		- Either I subscribe to all notifications of a type, and can only ever display one timer at a time
		- Or I need to know which instance of a timer to subscibe to, in which case I need to pass in the Timer object to the viewController before receiving notifications
- Dependancy injection
	- Does everything I want.  But, I am 

## Notes:
- xcode7 introduced errors that can be ignored:  [ Error: CGContextSaveGState: invalid context 0x0.](https://forums.developer.apple.com/thread/13683#50137)
