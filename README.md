# GeekSpeak-Show-Timer

During the recording of GeekSpeak, we need to plan for 2 inexactly placed breaks and a precise show length.  This is the timer we use to make that as easy as possible.

=======

## Known issues:
- Autolayout constraints are failing on an iPhone.
- Pause and Next buttons need to be graphic buttons for instant clarity.

## Todo:

- GeekSpeakButton UIButton subclass
	- use outline art
	- fill outline art on touch
	- animate radiating rings after sucessful touch
- Create animating buttons for start/pause and Next Segment buttons
- Create graphics for Add & Remove seconds buttons.
- Add GameKit discovery and networking between timers on multiple devices
- Animations:
	On section3 warning & alarm color, animate visibility of each ring radiating out (to catch everyone's eye)
- images need to be scaled and optimized for: @1x,@2x,@3x

- Layout:
	-iPhone 6+
		- when rotating, keep same viewController in view (master will collaps over detail when going horizontally compact)
		- when transitioning between rotations the  TimerViewController.layoutViewsForSize() is not being called when it needs to be
- NavigationBar issues to correct:
	- iPhone
		- timer view controller: change 'back' button to 'settings'
		- why does the 'back' button not animated the view over the timer view controller?
	- iPhone 6+
		- Settings View Controller is not always setting the button to 'Show timer' instead of 'hide'
	- iPad
		- Add a 'settings' button to the nav bar
	- All devices
		- Adjust layout based on navbar height on viewWillAppear and viewWillTransitionToSize:withTransitionCoordinator: 

- ~~Add color change to last segment ring at 2 minutes and a third color change at 30 seconds.~~ (done)
- ~~When 1st and 2nd segment finish, indicate time is still counting by creating a 5 degree gap that continues rotation at the same pace.~~ (done)
- ~~Fix labels under show times to scale based on text width~~ (done)
- ~~Showtime should always count up.~~ (done)
- ~~Section time should always count down. Except when all three segments are completed~~ (done)
- When show is done (three segments are completed)
	- ~~timer labels change to GeekSpeakBlue~~ (done)
	- Add and remove buttons should be disabled
	- Next Segment button animates away (reset button animates it back)
- Abstract out the hard coded definition of 3 segments with one minute breaks, into a definition file. Auto generate views based on this definition, allowing multiple show formats
- ~~Add test mode in settings app to switch between demo/testing and live show timer~~ (done)
- ~~Add keyArchivers to save state between launches~~ (done)
- ~~BUG: track down archiving state bug when timer is running and state preservation kicks in~~ (done)
- BUG: Nav button shows 'Hide' (not 'Show Timer') on start up

## Versions:
# v0.1
_(this version is tagged but, the tag isn't showing up in github for some reason)_

This is the initial version of the timer and used on the 8/3/15 recording of the show (aired 8/8/15).  It is useable, but truely a beta release.  Many views don't have any layout code and you can get the app in an unusable state on iPhones. [Here is a video demo of this version](https://www.youtube.com/watch?v=kwDyj1H7LJw)


## Architeture choices:
# Sharing Timer object between ultiple view controllers
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

