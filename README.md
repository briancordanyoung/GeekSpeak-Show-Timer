# GeekSpeak-Show-Timer

During the recording of GeekSpeak, we need to plan for 2 inexactly timed breaks and an precise show length.  This is the timer we use to make that a easy as possible.

# v0.1
This is the initial version of the timer and used on the 8/3/15 recording of the show (aired 8/8/15).  It is useable, but truely a beta release.  Many views don't have any layout code and you can get the app in an unusable state on iPhones.

## Known issues:
- Autolayout constraints of master view (slide over view) is non-existent.
- The labels showing the time are buggily choosing to count up or count down and the logic needs to be checked
- Pause and Next buttons need clear graphics
- subtract 1 second button is adding seconds!!!

## Design changes coming:
- Show time should always count up.
- Section time should always count down.
