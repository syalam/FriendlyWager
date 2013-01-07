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
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
