//
//  FWAPI.h
//  FriendlyWager
//
//  Created by Rashaad Sidique on 1/6/13.
//
//

#import <Foundation/Foundation.h>
#import "AFJSONRequestOperation.h"


typedef enum apiCall {
    kAPICallOpenRequests,
    kAPICallAssignedRequests,
    kAPICallFulfilledRequests,
    kAPICallFulfillRequest,
    kAPICallGetCategoryList,
    kAPICallLocationSearch,
    kAPICallSignUp,
    kAPICallCheckin,
} apiCall;

typedef enum OAuthProvider {
    OAuthProviderNone,
    OAuthProviderFacebook,
    OAuthProviderTwitter
} OAuthProvider;

@protocol FWAPIDelegate

@optional
- (void)FWAPICallSuccessful:(id)response;
- (void)FWAPICallFailed:(AFHTTPRequestOperation*)operation;


@end


#import <Foundation/Foundation.h>

@interface FWAPI : NSObject
///---------------------------------------------
/// @name Creating and Initializing API Clients
///---------------------------------------------

/**
 Creates and initializes an `FWAPI` object.
 
 @return The newly-initialized API client
 */

+(FWAPI *)sharedAPI;

///---------------------------------------------
/// @name Fetches a list of odds from the server
///---------------------------------------------
/**
 Retrieve list of odds from the server
 @return An array of odds
 @param params dictionary object containing captured request information
 Sport
 League
 StartDate
 EndDate
 */
+ (void)getOdds:(NSMutableDictionary*)params
        success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser))success
        failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser))failure;

///---------------------------------------------
/// @name Fetches a list of odds for soccer from the server
///---------------------------------------------
/**
 Retrieve list of odds from the server
 @return An array of odds for soccer games
 @param params dictionary object containing captured request information
 Sport
 League
 StartDate
 EndDate
 */
+ (void)getSoccerOdds:(NSMutableDictionary*)params
        success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser))success
        failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser))failure;

//---------------------------------------------
/// @name Fetches a list of scores and odds from the server
///---------------------------------------------
/**
 Retrieve list of odds and scores from the server
 @return An array of odds and scores
 @param params dictionary object containing captured request information
 Sport
 League
 StartDate
 EndDate
 */
+ (void)getScoresAndOdds:(NSMutableDictionary*)params
        success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser))success
        failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser))failure;

//---------------------------------------------
/// @name Fetches a list of soccer scores and odds from the server
///---------------------------------------------
/**
 Retrieve list of soccer odds and scores from the server
 @return An array of soccer odds and scores
 @param params dictionary object containing captured request information
 Sport
 League
 StartDate
 EndDate
 */
+ (void)getSoccerScoresAndOdds:(NSMutableDictionary*)params
                 success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser))success
                 failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser))failure;


@end
