//
//  FWHTTPClient.h
//  FriendlyWager
//
//  Created by Rashaad Sidique on 1/6/13.
//
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface FWHTTPClient : AFHTTPClient
+(FWHTTPClient *)sharedClient;
- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
           data:(NSData*)data
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
            data:(NSData*)data
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)putPath:(NSString *)path
     parameters:(NSDictionary *)parameters
           data:(NSData*)data
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)deletePath:(NSString *)path
        parameters:(NSDictionary *)parameters
              data:(NSData*)data
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(NSMutableURLRequest*)requestWithMethod:(NSString *)method
                                    path:(NSString *)path
                              parameters:(NSDictionary *)parameters
                                    data:(NSData*)data;

-(NSString*)userName;
-(NSString*)password;
@end
