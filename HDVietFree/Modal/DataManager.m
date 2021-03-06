//
//  DataManager.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager
@synthesize loginDelegate, listMovieDelegate, detailInfoMovieDelegate, loadLinkPlayMovieDelegate, searchMovieDelegate, reportBugDelegate, allSeasonDelegate, tvChannelDelegate;

//*****************************************************************************
#pragma mark -
#pragma mark ** Singleton object **
+(DataManager *)shared
{
    static dispatch_once_t once;
    static DataManager *share;
    dispatch_once(&once, ^{
        share = [[self alloc] init];
    });
    return share;
}

/*
 * Create init method to init base url
 */
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        // init manager AFHTTPRequestOperationManager
        self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        self.managerSSL = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrlSSL]];
        self.managerHDO = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrlHDO]];
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.managerHDO.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.managerHDO.responseSerializer = [AFJSONResponseSerializer serializer];
        self.managerSSL.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.managerSSL.responseSerializer = [AFJSONResponseSerializer serializer];
        [self.manager.requestSerializer setTimeoutInterval:kTimeOutIntervalSession];
        [self.managerSSL.requestSerializer setTimeoutInterval:kTimeOutIntervalSession];
        [self.managerHDO.requestSerializer setTimeoutInterval:kTimeOutIntervalSession];
        [self.managerHDO.requestSerializer setValue:kHTTPHeaderApplication
                         forHTTPHeaderField:kHTTPHeaderContentType];
        [self.managerHDO.requestSerializer setValue:@"iPad"
                                 forHTTPHeaderField:kHTTPHeaderUserAgent];
    }
    
    return self;
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Life Cycle Method **

- (void)setHTTPHeaderWithToken:(AFHTTPRequestOperationManager *)manager {
    [manager.requestSerializer setValue:[User share].accessToken
                  forHTTPHeaderField:kHTTPHeaderAccessToken];
    
}

- (void)setHTTPHeaderWithLogin:(AFHTTPRequestOperationManager *)manager {
    [manager.requestSerializer setValue:kHTTPHeaderApplication
                  forHTTPHeaderField:kHTTPHeaderContentType];
}

//*****************************************************************************
#pragma mark -
#pragma mark ** API HDO **
/*
 * GET TOKEN
 *
 * @param strUrl url string request
 */
- (void)getTokenWithUrl:(NSString *)strUrl withCompleteBlock:(completionBlock)completionBlock {
    [self.managerHDO GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:kMsg];
        if (getStatusResponseHDO(responseObject) == true) {
            
            // Success
            NSDictionary *result = [Utilities convertNullDictionary:[responseObject objectForKey:kResult]];
            if (result) {
                NSString *token = [result objectForKey:kToken];
                completionBlock(true, token);
            } else {
                completionBlock(false, kErrorDict);
            }
        } else {
            // Fail
            completionBlock(false, msg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            completionBlock(false, [error localizedDescription]);
    }];
}

/*
 * GET LOGIN HDO
 *
 * @param strUrl url string request
 */
- (void)getLoginHDOWithUrl:(NSString *)strUrl {
    [self.managerHDO GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:kMsg];
        if (getStatusResponseHDO(responseObject) == true) {
            
            // Success
            NSDictionary *result = [Utilities convertNullDictionary:[responseObject objectForKey:kResult]];
            if (result) {
                [loginDelegate loginAPISuccess:result];
            } else {
                [loginDelegate loginAPIFail:kErrorDict];
            }
        } else {
            // Fail
            [loginDelegate loginAPIFail:msg];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [loginDelegate loginAPIFail:[error localizedDescription]];
    }];
}

/*
 * GET LIST MOVIE HDO
 *
 * @param strUrl url string request
 */
- (void)getListMovieHDOWithUrl:(NSString *)strUrl andKey:(NSString *)key {
    [self.managerHDO GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:kMsg];
        if (getStatusResponseHDO(responseObject) == true) {
            
            // Success
            if (responseObject) {
                [listMovieDelegate loadListMovieAPISuccess:responseObject atTag:key andGenre:nil];
            } else {
                [listMovieDelegate loadListMovieAPIFail:kErrorDict];
            }
        } else {
            // Fail
            [listMovieDelegate loadListMovieAPIFail:msg];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [listMovieDelegate loadListMovieAPIFail:[error localizedDescription]];
    }];
}


//*****************************************************************************
#pragma mark -
#pragma mark ** API HDViet **
/*
 * GET LOGIN
 *
 * @param strUrl url string request
 */
- (void)getLoginWithUrl:(NSString *)strUrl {
    [self.managerSSL.requestSerializer setValue:kHTTPHeaderApplication
                     forHTTPHeaderField:kHTTPHeaderContentType];
    [self.managerSSL GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:kE] integerValue] == kRequestSuccess) {
            
            // Success
            
            if ([Utilities convertNullDictionary:[responseObject objectForKey:kR]]) {
                [loginDelegate loginAPISuccess:[responseObject objectForKey:kR]];
            } else {
                [loginDelegate loginAPIFail:kErrorDict];
            }
        } else {
            // Fail
            [loginDelegate loginAPIFail:[responseObject objectForKey:kR]];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (errorString(k400BadRequestString)) {
            [loginDelegate loginAPIFail:kInvalidSession];
        } else if (errorString(k502BadRequestString) || errorString(k500BadRequestString) ) {
            [loginDelegate loginAPIFail:kServerOverload];
        } else {
            [loginDelegate loginAPIFail:[error localizedDescription]];
        }
    }];
}

/*
 * GET LIST MOVIE
 *
 * @param strUrl url string request
 */
- (void)getListMovieByGenreWithUrl:(NSString *)strUrl atTag:(NSString *)tagMovie andGenre:(NSString *)genre {
    [self.manager.requestSerializer setValue:[UserHDV share].accessToken forHTTPHeaderField:kHTTPHeaderAccessToken];
    [self.manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:kError] integerValue] == kRequestSuccess) {
            
            // Success
            if ([Utilities convertNullDictionary:[responseObject objectForKey:kData]]) {
                [listMovieDelegate loadListMovieAPISuccess:[responseObject objectForKey:kData] atTag:tagMovie andGenre:genre];
            } else {
                [listMovieDelegate loadListMovieAPIFail:kErrorDict];
            }
        } else {
            
            // Fail
            [listMovieDelegate loadListMovieAPIFail:[responseObject objectForKey:kMessage]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (errorString(k400BadRequestString)) {
            [listMovieDelegate loadListMovieAPIFail:kInvalidSession];
        } else if (errorString(k502BadRequestString) || errorString(k500BadRequestString) ) {
            [listMovieDelegate loadListMovieAPIFail:kServerOverload];
        } else {
            [listMovieDelegate loadListMovieAPIFail:[error localizedDescription]];
        }
        
    }];
}

/*
 * GET DETAIL INFORMATION MOVIE
 *
 * @param strUrl url string request
 */
- (void)getDetailInformationMovieWithUrl:(NSString *)strUrl andMovie:(Movie *)movie {
    [self.managerSSL.requestSerializer setValue:[UserHDV share].accessToken forHTTPHeaderField:kHTTPHeaderAccessToken];
    [self.managerSSL GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:kE] integerValue] == kRequestSuccess) {
            
            // Success
            if ([Utilities convertNullDictionary:[responseObject objectForKey:kR]]) {
                [detailInfoMovieDelegate  loadDetailInformationMovieAPISuccess:[responseObject objectForKey:kR]];
            } else {
                [detailInfoMovieDelegate loadDetailInformationMovieAPIFail:kErrorDict];
            }
            
        } else {
            // Fail
            [detailInfoMovieDelegate loadDetailInformationMovieAPIFail:[responseObject objectForKey:kR]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (errorString(k400BadRequestString)) {
            [detailInfoMovieDelegate loadDetailInformationMovieAPIFail:kInvalidSession];
        }else if (errorString(k502BadRequestString) || errorString(k500BadRequestString) ) {
            [detailInfoMovieDelegate loadDetailInformationMovieAPIFail:kServerOverload];
        }else {
           [detailInfoMovieDelegate loadDetailInformationMovieAPIFail:[error localizedDescription]];
        }
        
    }];
}

/*
 * LOAD LINK PLAY
 *
 * @param strUrl url string request
 */
- (void)getLinkPlayMovie:(NSString *)strUrl {
    [self.managerSSL.requestSerializer setValue:kHTTPHeaderApplication
                             forHTTPHeaderField:kHTTPHeaderContentType];
    [self.managerSSL GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:kE] integerValue] == kRequestSuccess) {
            
            // Success
            if ([Utilities convertNullDictionary:[responseObject objectForKey:kR]]) {
                [loadLinkPlayMovieDelegate  loadLinkPlayMovieAPISuccess:[responseObject objectForKey:kR]];
            } else {
                // Fail
                [loadLinkPlayMovieDelegate  loadLinkPlayMovieAPIFail:kErrorDict];
            }
            
        } else {
            
            // Fail
            [loadLinkPlayMovieDelegate  loadLinkPlayMovieAPIFail:[responseObject objectForKey:kR]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (errorString(k400BadRequestString)) {
            [loadLinkPlayMovieDelegate  loadLinkPlayMovieAPIFail:kInvalidSession];
        } else if (errorString(k502BadRequestString) || errorString(k500BadRequestString) ) {
            [loadLinkPlayMovieDelegate  loadLinkPlayMovieAPIFail:kServerOverload];
        } else {
            [loadLinkPlayMovieDelegate  loadLinkPlayMovieAPIFail:[error localizedDescription]];
        }
        
    }];
}

/*
 * SEARCH MOVIE
 *
 * @param strUrl url string request
 */
- (void)searchMovieWithUrl:(NSString *)strUrl {
    [self.manager.requestSerializer setValue:[UserHDV share].accessToken forHTTPHeaderField:kHTTPHeaderAccessToken];
    [self.manager GET:[strUrl encodeNSUTF8:strUrl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:kError] integerValue] == kRequestSuccess) {
            // Success
            if ([Utilities convertNullDictionary:[[responseObject objectForKey:kData] objectForKey:kResponse]]) {
                // Success
                [searchMovieDelegate searchMovieAPISuccess:[[responseObject objectForKey:kData] objectForKey:kResponse]];
            } else {
                // Fail
                [searchMovieDelegate searchMovieAPIFail:kErrorDict];
            }
            
        } else {
            
            // Fail
            [searchMovieDelegate searchMovieAPIFail:[responseObject objectForKey:kMessage]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (errorString(k400BadRequestString)) {
            [searchMovieDelegate searchMovieAPIFail:kInvalidSession];
        } else if (errorString(k502BadRequestString) || errorString(k500BadRequestString) ) {
            [searchMovieDelegate searchMovieAPIFail:kServerOverload];
        } else {
            [searchMovieDelegate searchMovieAPIFail:[error localizedDescription]];
        }
    }];
}

/*
 * REPORT BUG
 *
 * @param strUrl url string request
 */
- (void)reportBugWithData:(NSString *)data {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:kUrlGoogleReportBug]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:kPostMethod];
    [request setValue: kHTTPHeaderValue forHTTPHeaderField:kHTTPHeaderContentType];
    [request setHTTPBody: [stringToAccent(data) dataUsingEncoding:NSMacOSRomanStringEncoding  allowLossyConversion:YES]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [reportBugDelegate reportBugAPISuccess:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [reportBugDelegate reportBugAPIFail:kReportFail];
        
    }];
    [op start];
}

/*
 * GET ALL SEASON MOVIE
 *
 * @param strUrl url string request
 */
- (void)getAllSeasonMovieUrl:(NSString *)strUrl {
    self.managerSSL.responseSerializer.acceptableContentTypes = nil;
    [self.managerSSL GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:kE] integerValue] == kRequestSuccess) {
            
            // Success
            if ([Utilities convertNullDictionary:[responseObject objectForKey:kR]]) {
                [allSeasonDelegate  getAllSeasonAPISuccess:[responseObject objectForKey:kR]];
            } else {
                [allSeasonDelegate getAllSeasonAPIFail:kErrorDict];
            }
            
        } else {
            // Fail
            [allSeasonDelegate getAllSeasonAPIFail:[responseObject objectForKey:kR]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (errorString(k400BadRequestString)) {
            [allSeasonDelegate getAllSeasonAPIFail:kInvalidSession];
        }else if (errorString(k502BadRequestString) || errorString(k500BadRequestString) ) {
            [allSeasonDelegate getAllSeasonAPIFail:kServerOverload];
        }else {
            [allSeasonDelegate getAllSeasonAPIFail:[error localizedDescription]];
        }
        
    }];
}

/*
 * Get all tv channel
 *
 * @param strUrl url string request
 */
- (void)getALlTVChannel:(NSString *)requestData {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:kUrlTvChannelHTVOnline]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:kPostMethod];
    [request setValue: kHTTPHeaderContentTypeValue forHTTPHeaderField:kHTTPHeaderContentType];
    [request setValue: kHTTPHeaderAuthorizationValue forHTTPHeaderField:kHTTPHeaderAuthorization];
    [request setValue: kHTTPHeaderUserAgentValue forHTTPHeaderField:kHTTPHeaderUserAgent];
    [request setHTTPBody:[requestData dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [tvChannelDelegate getAllTVChannelAPISuccess:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [tvChannelDelegate getAllTVChannelAPIFail:[error localizedDescription]];
        
    }];
    [op start];
}


@end
