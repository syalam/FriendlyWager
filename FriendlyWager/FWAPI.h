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
/// @name Fetches a game preview from the server
///---------------------------------------------
/**
 Retrieve game preview from the server
 @return A dictionary of odds
 @param params dictionary object containing captured request information
 Sport
 League
 GameId
 */
+ (void)getGamePreview:(NSMutableDictionary*)params
                 success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser))success
                 failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser))failure;

//---------------------------------------------
/// @name Fetches a list of GameId's for which Previews are available
///---------------------------------------------
/**
 Retrieve a list of GameId's for which Previews are available from the server
 @return A list of GameId's
 @param params dictionary object containing captured request information
 Sport
 League
 StartDate
 EndDate
 */
+ (void)getPreviewList:(NSMutableDictionary*)params
               success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser))success
               failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser))failure;

//---------------------------------------------
/// @name Fetches Teasers and subsets of Data to build an intro page for each sport///---------------------------------------------
/**
 Retrieve a link to a splash screen from the server
 @return strings of information
 @param params dictionary object containing captured request information
 Sport
 League
 */
+ (void)getSplashScreen:(NSMutableDictionary*)params
               success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser))success
               failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser))failure;

@end
