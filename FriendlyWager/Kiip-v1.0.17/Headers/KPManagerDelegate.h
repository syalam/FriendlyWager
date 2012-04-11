/*
 *  KPManagerDelegate.h
 *  Kiip
 *
 *  Created on 2/17/11.
 *  Copyright 2011 Kiip, Inc. All rights reserved.
 *
 */

#import "KPUIConstants.h"

@class KPManager;

/*!
 * @protocol KPManagerDelegate
 * @abstract This protocol defines optional method callbacks for asynchronous calls from KPManager
 * as well as notification state callbacks.
 */
@protocol KPManagerDelegate <NSObject>
@optional

/*!
 * @method willPresentNotification
 * @abstract Notifies the delegate when the
 * notification is about to be shown on the screen.
 * @param rid The reward id.
 */
- (void) willPresentNotification:(NSString*)rid;

/*!
 * @method  didPresentNotification
 * @abstract ￼Notifies the delegate when the notification
 * has been shown on the screen.
 * @param rid The reward id.
 */
- (void) didPresentNotification:(NSString*)rid;

/*!
 * @method  willCloseNotification
 * @abstract ￼Notifies the delegate when the notification
 * is about to close. A notification can close when the banner
 * disappears from the view position or the webview has
 * been dismissed.
 * @param rid The reward id.
 */
- (void) willCloseNotification:(NSString*)rid;

/*!
 * @method  didCloseNotification
 * @abstract ￼Notifies the delegate when the notification
 * has closed. A notification can close when the banner
 * disappears from the view position or the webview has
 * been dismissed.
 * @param rid The reward id.
 */
- (void) didCloseNotification:(NSString*)rid;

/*!
 * @method  willShowWebView
 * @abstract ￼Notifies the delegate when the webview
 * is about to show.
 * @param rid The reward id.
 */
- (void) willShowWebView:(NSString*)rid;

/*!
 * @method  didShowWebView
 * @abstract ￼Notifies the delegate when the webview
 * has shown.
 * @param rid The reward id.
 */
- (void) didShowWebView:(NSString*)rid;

/*!
 * @method willCloseWebView:
 * @abstract Notifies the delegate when the webview
 * will be closed.
 * @param rid The reward id.
 */
- (void) willCloseWebView:(NSString*)rid;

/*!
 * @method didCloseWebView:
 * @abstract Notifies the delegate when the webview
 * has been closed.
 * @param rid The reward id.
 */
- (void) didCloseWebView:(NSString*)rid;

/*!
 * @method managerDidStartSession:
 * @abstract Notifies the delegate that the manager
 * has successfuly created a session.
 * @param manager ￼
 */
- (void) manager:(KPManager*)manager didStartSession:(NSDictionary*)resource;

/*!
 * @method managerDidEndSession:
 * @abstract Notifies the delegate that the manager
 * has successfully closed a session.
 * @param manager ￼
 */
- (void) managerDidEndSession:(KPManager*)manager;

/*!
 * @method manager:didUnlockAchievement:
 * @abstract Notifies the delegate that the manager
 * has successfully unlocked an achievement.
 * @param manager
 * @param resource
 */
- (void) manager:(KPManager*)manager didUnlockAchievement:(NSDictionary*)resource;

/*!
 * @method manager:didGetActivePromos:
 * @abstract Notifies the delegate that the manager
 * has successfully retrieved a dictionary of the live promos.
 * @param manager ￼
 * @param resource ￼
 */
- (void) manager:(KPManager*)manager didGetActivePromos:(NSArray*)promos;

/*!
 * @method managerDidUpdateLocation:
 * @abstract Notifies the delegate that the manager has
 * successfully updated the session's location.
 * @param manager ￼
 */
- (void) managerDidUpdateLocation:(KPManager*)manager;

/*!
 * @method manager:didUpdateLeaderboard:
 * @abstract ￼Notifies the delegate that the manager has
 * successfully updated the leader board.
 * @param manager
 * @param rewardId
 */
- (void) manager:(KPManager*)manager didUpdateLeaderboard:(NSDictionary*)resource;

/*!
 * @method manager:didReceiveError:
 * @abstract This callback passes along the error
 * that was generated from a request to the Kiip API.
 * @param manager ￼The manager that triggered the error.
 * @param error ￼
 */
- (void) manager:(KPManager*)manager didReceiveError:(NSError*)error;

/*!
 * @method didStartSwarm
 * @abstract Notifies the delegate when a user has
 * selected to participate in a Kiip Swarm
 * @param leaderboard_id The leaderboard of the game mode to begin
 */
- (void) didStartSwarm:(NSString*)leaderboard_id;

/*!
 * @method didReceiveContent:quantity:
 * @abstract Notifies the delegate that the user has won
 * some in-game content.
 * @param content The content_id the user has won.
 * @param quantity The quanitity of content the user has won.
 * @param receipt The signature of the transaction.
 */
- (void) didReceiveContent:(NSString*)content quantity:(int)quantity withReceipt:(NSDictionary*)receipt;

@end
