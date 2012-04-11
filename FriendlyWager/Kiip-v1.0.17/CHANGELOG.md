## Kiip SDK Changelog

Version 1.0.17

* Critical bug fix: Crashed if notification image load failed.

Version 1.0.16

* Deprecated use of UDID. For test devices, please use the the device's Wi-Fi MAC address.
  This can be read through `[[KPManager sharedManager] deviceIdentifier]`.
* Improved reward loading times
* Added dependency: libxml2.dylib framework
* Fix: manager:didReceiveError: has the correct NSError structure
* Small memory leak fix
* Small bug fixes

Version 1.0.15

* Deprecated: startSession, endSession -- starting and ending sessions now happen automatically
* Deprecated: init* withTags:
* Improved session management
* Small bug fixes

Version 1.0.14

* Changed GCC_THUMB_SUPPORT[arch=armv6]=NO for Unity support on ARMv6
* Updated example project
* Performance improvements

Version 1.0.13

* Fix: NSNull bug introduced in v1.0.10
* Fix: Hopefully solve the issues some developers were having with typedef in KPUIConstants.h

Version 1.0.12

* Fix: compatibility issues with 3.x and crashes introduced in v1.0.11

Version 1.0.11

* Fix: compile static library for armv6 and armv7

Version 1.0.10

* Added a receipt to the in-game content callback for security.
* Added touch actions to the notification.
* Added support for dynamic notification layouts.
* Performance optimizations.
* Fix: center notifications when device is upside down.

Version 1.0.9

* Added KPManager updateUserInfo that takes a dictionary of user information. Currently supports:
    * alias - player's name to be displayed in a swarm.
    * email - pre-populate reward units with the user's email address.
* Added support for Kiip Swarm.
* Added support for Kiip in-game content.
* Added support for landscape promos.
* Promos will no longer queue if a unit is showing.
* Fix: didUpdateLocation wasn't being called.

Version 1.0.8

New:

* Added support for legacy devices (3.0+)
* Added optional tags to init and startSession
	- [[KPManager sharedManager] initWithKey:secret:withTags:]
	- [[KPManager sharedManager] startSessionWithTags:]
* [KPManager startSession:], [KPManager initWithKey:secret:] and [KPManager initWithKey:secret:testFrequency:] will receive promos if available.
* Unit position can now be toggled from the web interface at http://kiip.me (Notification Top|Bottom, Fullscreen)
* Loading dialog text changes depending on the unit it is loading.

If updating from a previous version:

* Fixed detecting current orientation when rotation lock is on.
* Make sure start/end session happens in applicationWillEnterForeground: and applicationDidEnterBackground: respectively
* Removed the need for -all_load and -force_load in Other Linker Flags.
* Deprecated [KPManager presentPromo:].
* Deprecated [KPManager presentReward:position:] and [KPManager presentReward:position:onView], instead set position in the resource NSDictionary and use [KPManager presentReward:] and [KPManager presentReward:onView].
* Deprecated [KPManagerDelegate positionForReward:]
* Fixed TouchJSON namespace conflict.
* Fixed TouchFoundation namespace conflict.
* Fixed SDURLCache namespace conflict.
* Fixed ASIHTTPRequest namespace conflict.
* Fixed memory leak.
* Other small bug fixes.

Version 1.0.7

* Added optional tags to Achievement Unlock and Leaderboard Score
    [[KPManager sharedManager] updateScore: onLeaderboard: withTags:]
    [[KPManager sharedManager] unlockAchievement: withTags:]
* Updated notification image preloading
* Added [[KPManager sharedManager] getActivePromos]
* Added ability to customize text of notifications
* Added functionality to provide resources to create custom notifications

Version 1.0.6

* Modified landscape loading view position
* Improved session logging
* Changed the following function names:
    KPManager
        launchSession           -> startSession
        closeSession            -> endSession
    KPManagerDelegate
        managerDidCreateSession -> managerDidStartSession
        managerDidCloseSession  -> managerDidEndSession

Version 1.0.5

* Improved handling of multiple rewards in a session

Version 1.0.4

* Added custom background for Kiip loading indicator

Version 1.0.3

* Improved status bar functionality
* Updated notifications without an image functionality

Version 1.0.2

* Fixed Kiip session handling

Version 1.0.1

* Modified spinner background
* Modified OAuth parameter handling
* Fixed static variable issues

Version 1.0.0

* First version.