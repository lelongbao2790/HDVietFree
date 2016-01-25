//
//  DataManager.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager
@synthesize loginDelegate;

//*****************************************************************************
#pragma mark -
#pragma mark ** Singleton object **
+ (DataManager *)shared {
    static DataManager *__sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *baseURL = kBaseUrlSSL;
        __sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    });
    
    return __sharedManager;
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Life Cycle Method **
- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        
        // Init request and response serializer
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        [self.requestSerializer setValue:kHTTPHeaderApplication
                      forHTTPHeaderField:kHTTPHeaderContentType];
    }
    return self;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSURLResponse *, id, NSError *))originalCompletionHandler {
    return [super dataTaskWithRequest:request
                    completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                        
                        // If there's an error, store the response in it if we've got one.
                        if (error && responseObject) {
                            
                            if (error.userInfo) { // Already has a dictionary, so we need to add to it.
                                
                                NSMutableDictionary *userInfo = [error.userInfo mutableCopy];
                                userInfo[kErrorResponseObjectKey] = responseObject;
                                error = [NSError errorWithDomain:error.domain
                                                            code:error.code
                                                        userInfo:[userInfo copy]];
                            }
                            else { // No dictionary, make a new one.
                                error = [NSError errorWithDomain:error.domain
                                                            code:error.code
                                                        userInfo:@{kErrorResponseObjectKey: responseObject}];
                            }
                        }
                        
                        // Call the original handler.
                        if (originalCompletionHandler) {
                            originalCompletionHandler(response, responseObject, error);
                        }
                    }];
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Helper Method **
/*
 * POST LOGIN
 *
 * @param strUrl url string request
 */
- (void)postLoginWithUrl:(NSString *)strUrl {
    
    [self GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([[responseObject objectForKey:kE] integerValue] == kRequestSuccess) {
            
            // Success
            [loginDelegate loginAPISuccess:[responseObject objectForKey:kR]];
        } else {
            
            // Fail
            [loginDelegate loginAPIFail:[responseObject objectForKey:kR]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [loginDelegate loginAPIFail:kCannotConnectToServer];
    }];
}

@end
