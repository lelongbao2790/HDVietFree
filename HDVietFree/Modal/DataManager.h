//
//  DataManager.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "UIImageLoader.h"

typedef void (^completionBlock)(BOOL success, UIImageLoaderImage * image);
typedef void (^completionDownload)(BOOL success, UIImage * image);

@interface DataManager : NSObject {
     NSObject<LoginDelegate> *loginDelegate;
     NSObject<ListMovieByGenreDelegate> *listMovieDelegate;
     NSObject<DetailInformationMovieDelegate> *detailInfoMovieDelegate;
     NSObject<LoadLinkPlayMovieDelegate> *loadLinkPlayMovieDelegate;
     NSObject<SearchMovieDelegate> *searchMovieDelegate;
     NSObject<ReportBugDelegate> *reportBugDelegate;
     NSObject<AllSeasonDelegate> *allSeasonDelegate;
     NSObject<TVChannelDelegate> *tvChannelDelegate;
}
// Init request operation manager
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@property (strong, nonatomic) AFHTTPRequestOperationManager *managerSSL;

// Delegate
@property (strong, nonatomic) NSObject *loginDelegate;
@property (strong, nonatomic) NSObject *listMovieDelegate;
@property (strong, nonatomic) NSObject *detailInfoMovieDelegate;
@property (strong, nonatomic) NSObject *loadLinkPlayMovieDelegate;
@property (strong, nonatomic) NSObject *searchMovieDelegate;
@property (strong, nonatomic) NSObject *reportBugDelegate;
@property (strong, nonatomic) NSObject *allSeasonDelegate;
@property (strong, nonatomic) NSObject *tvChannelDelegate;
//*****************************************************************************
#pragma mark -
#pragma mark ** Singleton object **
+ (DataManager *)shared;

//*****************************************************************************
#pragma mark -
#pragma mark ** Helper Method **
/*
 * POST LOGIN
 *
 * @param strUrl url string request
 */
- (void)getLoginWithUrl:(NSString *)strUrl;

/*
 * GET LIST MOVIE
 *
 * @param strUrl url string request
 */
- (void)getListMovieByGenreWithUrl:(NSString *)strUrl atTag:(NSString *)tagMovie andGenre:(NSString *)genre;

/*
 * GET DETAIL INFORMATION MOVIE
 *
 * @param strUrl url string request
 */
- (void)getDetailInformationMovieWithUrl:(NSString *)strUrl andMovie:(Movie *)movie;

/*
 * LOAD LINK PLAY
 *
 * @param strUrl url string request
 */
- (void)getLinkPlayMovie:(NSString *)strUrl;

/*
 * SEARCH MOVIE
 *
 * @param strUrl url string request
 */
- (void)searchMovieWithUrl:(NSString *)strUrl;

/*
 * REPORT BUG
 *
 * @param strUrl url string request
 */
- (void)reportBugWithData:(NSString *)data;

/*
 * DOWNLOAD IMAGE
 *
 * @param strUrl url string request
 */
- (void)downloadImageWithUrl:(NSString *)url completionBlock:(completionBlock)completionBlock;

/*
 * GET ALL SEASON MOVIE
 *
 * @param strUrl url string request
 */
- (void)getAllSeasonMovieUrl:(NSString *)strUrl;

/*
 * Get all tv channel
 *
 * @param strUrl url string request
 */
- (void)getALlTVChannel:(NSString *)requestData;

@end
