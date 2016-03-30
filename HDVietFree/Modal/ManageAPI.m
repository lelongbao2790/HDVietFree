//
//  ManageAPI.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "ManageAPI.h"

@implementation ManageAPI

/*
 * Singleton
 */
+ (ManageAPI *)share {
    static dispatch_once_t once;
    static ManageAPI *share;
    dispatch_once(&once, ^{
        share = [self new];
    });
    return share;
}

/*
 * login API
 */
- (void)loginAPI:(NSString *)userName andPass:(NSString *)password {
    if ([ServerType share].type == kTypeHDViet) {
        NSString *strUrl = [NSString stringWithFormat:kUrlLogin, userName, [password MD5]];
        DLOG(@"Login with url:%@", strUrl);
        [[DataManager shared] getLoginWithUrl:strUrl];
    } else {
        // Get token
        [[DataManager shared] getTokenWithUrl:kUrlGetTokenHDO withCompleteBlock:^(BOOL success, NSString *token) {
            if (success) {
                
                // Login HDO
                NSString *strUrl = [NSString stringWithFormat:kUrlLoginHDO, token , userName, password];
                [[DataManager shared] getLoginHDOWithUrl:strUrl];
                
            } else {
                ProgressBarDismissLoading(kEmptyString);
                [Utilities showiToastMessage:token];
            }
        }];
    }
    
    
}

/*
 * Load list movie API
 */
- (void)loadListMovieHDOAPI:(NSString *)url andKey:(NSString *)key {
    DLOG(@"Load list movie HDO with url:%@", url);
    [[DataManager shared] getListMovieHDOWithUrl:url andKey:key];
}


/*
 * Load list movie API
 */
- (void)loadListMovieAPI:(NSInteger)genre tag:(NSString *)tagMovie andPage:(NSInteger)page {
    NSString *strUrl = [NSString stringWithFormat:kUrlListMovieByGenre, (int)genre, tagMovie, (int)page];
    DLOG(@"Load list movie with url:%@", strUrl);
    [[DataManager shared] getListMovieByGenreWithUrl:strUrl atTag:tagMovie andGenre:stringFromInteger([MovieSearch share].genreMovie)];
}

/*
 * Load detail information movie API
 */
- (void)loadDetailInfoMovieAPI:(Movie*)movie {
    NSString *strUrl = [NSString stringWithFormat:kUrlDetailMovie, movie.movieID];
    DLOG(@"Load detail information movie with url:%@", strUrl);
    [[DataManager shared] getDetailInformationMovieWithUrl:strUrl andMovie:movie];
}

/*
 * Load all season movie
 */
- (void)loadAllSeasonMovieAPI:(Movie*)movie {
    NSString *strUrl = [NSString stringWithFormat:kUrlAllSeason, movie.movieID];
    DLOG(@"Load all season movie with url:%@", strUrl);
    [[DataManager shared] getAllSeasonMovieUrl:strUrl];
}

/*
 * Load detail information movie API
 */
- (void)loadLinkToPlayMovie:(Movie*)movie andEpisode:(NSInteger)episode {
    NSString *strUrl = [NSString stringWithFormat:kUrlPlayMovie, movie.movieID, [UserHDV share].accessToken, (int)episode];
    DLOG(@"Load link to play movie with url:%@", strUrl);
    [[DataManager shared] getLinkPlayMovie:strUrl];
}

/*
 * Search movie
 */
- (void)searchMovieWithKeyword:(NSString *)keyword {
    NSString *strUrl = [NSString stringWithFormat:kUrlSearchMovieWithKeyword, keyword];
    
    DLOG(@"Search movie with :%@", strUrl);
    [[DataManager shared] searchMovieWithUrl:strUrl];
}

@end
