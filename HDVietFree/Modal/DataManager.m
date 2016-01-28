//
//  DataManager.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager
@synthesize loginDelegate, listMovieDelegate, detailInfoMovieDelegate;

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
    }
    
    return self;
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Life Cycle Method **
- (instancetype)initWithBaseURL:(NSURL *)url andBaseSSL:(NSURL *)urlSSL
{
    self = [super init];
    
    if (self) {
        // init manager AFHTTPRequestOperationManager
        self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
        self.managerSSL = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:urlSSL];
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.managerSSL.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.managerSSL.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

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
            [loginDelegate loginAPISuccess:[responseObject objectForKey:kR]];
        } else {
            
            // Fail
            [loginDelegate loginAPIFail:[responseObject objectForKey:kR]];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [loginDelegate loginAPIFail:[error localizedDescription]];
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
            [listMovieDelegate loadListMovieAPISuccess:[responseObject objectForKey:kData] atTag:tagMovie andGenre:genre];
        } else {
            
            // Fail
            [listMovieDelegate loadListMovieAPIFail:[responseObject objectForKey:kMessage]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [listMovieDelegate loadListMovieAPIFail:[error localizedDescription]];

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
            [detailInfoMovieDelegate  loadDetailInformationMovieAPISuccess:[responseObject objectForKey:kR]];
        } else {
            
            // Fail
            [detailInfoMovieDelegate loadDetailInformationMovieAPIFail:[responseObject objectForKey:kR]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [detailInfoMovieDelegate loadDetailInformationMovieAPIFail:[error localizedDescription]];
    }];
}

@end
