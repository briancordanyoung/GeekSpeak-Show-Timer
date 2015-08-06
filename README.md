# GeekSpeak-Show-Timer

During the recording of GeekSpeak, we need to plan for 2 inexactly timed breaks and an precise show length.  This is the timer we use to make that a easy as possible.

=======

## Known issues:
- Autolayout constraints of master view (slide over view) is non-existent.
- Pause and Next buttons need clear graphics
- Subtract 1 second button is adding seconds!!!

## Todo:
- images need to be scaled and optimized for: @1x,@2x,@3x
- Fix labels under show times to scale based on text width
- Create animating buttons for start/pause and Next Segment buttons
- Create graphics for Add & Remove seconds buttons.
- When 1st and 2nd segment finish, indicate time is still counting by creating a 5 degree gap that continues rotation at the same pace.
- ~~Showtime should always count up. (done)~~
- ~~Section time should always count down. Except when all three segments are completed (done)~~
- When show is done (three segments are completed)
	- ~~timer labels change to GeekSpeakBlue (done)~~
	- Add and remove buttons are disabled
	- Next Segment button animates away (reset button animates it back)
- Add GameKit discovery and networking between timers on multiple devices
- Abstract out the hard coded definition of 3 segments with one minute breaks in to a definition file. Auto generate views based on this definition, allowing multiple show formats
- ~~Add test mode in settings app to switch between demo/testing and live show timer (done)~~
- ~~Add keyArchivers to save state between launches done~~
	- track down arching bug when timer is running and state preservation kicks in

## Versions (tagged):
# v0.1
This is the initial version of the timer and used on the 8/3/15 recording of the show (aired 8/8/15).  It is useable, but truely a beta release.  Many views don't have any layout code and you can get the app in an unusable state on iPhones.
