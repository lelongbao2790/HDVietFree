//
//  DataManager.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager
@synthesize loginDelegate, listMovieDelegate, detailInfoMovieDelegate, loadLinkPlayMovieDelegate, searchMovieDelegate;

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
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.managerSSL.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.managerSSL.responseSerializer = [AFJSONResponseSerializer serializer];
        [self.manager.requestSerializer setTimeoutInterval:kTimeOutIntervalSession];
        [self.managerSSL.requestSerializer setTimeoutInterval:kTimeOutIntervalSession];
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
#pragma mark ** Helper Method **
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
        if ([[error localizedDescription] isEqualToString:k400BadRequestString]) {
            [loginDelegate loginAPIFail:kInvalidSession];
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
    [self.manager.requestSerializer setValue:[User share].accessToken forHTTPHeaderField:kHTTPHeaderAccessToken];
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
        if ([[error localizedDescription] isEqualToString:k400BadRequestString]) {
            [listMovieDelegate loadListMovieAPIFail:kInvalidSession];
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
    [self.managerSSL.requestSerializer setValue:[User share].accessToken forHTTPHeaderField:kHTTPHeaderAccessToken];
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
        if ([[error localizedDescription] isEqualToString:k400BadRequestString]) {
            [detailInfoMovieDelegate loadDetailInformationMovieAPIFail:kInvalidSession];
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
        if ([[error localizedDescription] isEqualToString:k400BadRequestString]) {
            [loadLinkPlayMovieDelegate  loadLinkPlayMovieAPIFail:kInvalidSession];
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
    [self.manager.requestSerializer setValue:[User share].accessToken forHTTPHeaderField:kHTTPHeaderAccessToken];
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
        if ([[error localizedDescription] isEqualToString:k400BadRequestString]) {
            [searchMovieDelegate searchMovieAPIFail:kInvalidSession];
        } else {
            [searchMovieDelegate searchMovieAPIFail:[error localizedDescription]];
        }
    }];
}

@end
