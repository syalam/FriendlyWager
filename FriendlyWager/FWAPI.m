//
//  FWAPI.m
//  FriendlyWager
//
//  Created by Rashaad Sidique on 1/6/13.
//
//

#import "FWAPI.h"
#import "FWHTTPClient.h"

static NSString * const kBMHTTPClientBaseURLString = @"http://services.chalkgaming.com/ChalkServices.asmx?op=";
static NSString * const userName = @"MajfyT673";
static NSString * const password = @"Mhfgsy63Jd";

@implementation FWAPI

+ (NSURL *)baseURL
{
    return [NSURL URLWithString:kBMHTTPClientBaseURLString];
}

#pragma mark - Singleton Method
+ (FWAPI *)sharedAPI {
    static FWAPI *_sharedAPI = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAPI = [[FWAPI alloc] init];
    });
    
    return _sharedAPI;
}

#pragma mark - Helper Methods
+ (FWHTTPClient*)setupHTTPClient {
    FWHTTPClient *httpClient = [FWHTTPClient sharedClient];
    [httpClient setDefaultHeader:@"Content-Type" value:@"text/xml"];
    
    return httpClient;
}

+ (void)getOdds:(NSMutableDictionary*)params
                 success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser))success
                 failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser))failure {
    FWHTTPClient *httpClient = [self setupHTTPClient];
    [params setObject:userName forKey:@"Username"];
    [params setObject:password forKey:@"Password"];
    [httpClient getXMLPath:@"Odds" parameters:params data:nil success:success failure:failure];
}

+ (void)getScoresAndOdds:(NSMutableDictionary*)params
                 success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser))success
                 failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser))failure {
    FWHTTPClient *httpClient = [self setupHTTPClient];
    [params setObject:userName forKey:@"Username"];
    [params setObject:password forKey:@"Password"];
    [httpClient getXMLPath:@"OddsAndScores" parameters:params data:nil success:success failure:failure];
        
}

+ (void)getGamePreview:(NSMutableDictionary*)params
               success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser))success
               failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser))failure {
    FWHTTPClient *httpClient = [self setupHTTPClient];
    [params setObject:userName forKey:@"Username"];
    [params setObject:password forKey:@"Password"];
    [httpClient getXMLPath:@"Preview" parameters:params data:nil success:success failure:failure];
}

+ (void)getPreviewList:(NSMutableDictionary*)params
               success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser))success
               failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser))failure {
    FWHTTPClient *httpClient = [self setupHTTPClient];
    [params setObject:userName forKey:@"Username"];
    [params setObject:password forKey:@"Password"];
    [httpClient getXMLPath:@"PreviewList" parameters:params data:nil success:success failure:failure];
}

+ (void)getSplashScreen:(NSMutableDictionary*)params
                success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser))success
                failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser))failure {
    FWHTTPClient *httpClient = [self setupHTTPClient];
    [params setObject:userName forKey:@"Username"];
    [params setObject:password forKey:@"Password"];
    [httpClient getXMLPath:@"SplashScreen" parameters:params data:nil success:success failure:failure];
}

@end
