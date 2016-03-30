//
//  Source.m
//  HomeMovie
//
//  Created by Bao (Brian) L. LE on 3/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "Source.h"

@implementation Source

+ (Source *)share {
    static dispatch_once_t once;
    static Source *share;
    dispatch_once(&once, ^{
        share = [self new];
    });
    return share;
}

/*
 * Init source
 */
- (void)initSource:(NSInteger)lastListMovie andTable:(UITableView *)tbvListMovie andCompletion:(completionDataBlock)completion {
    Source *newSource = [Source share];
    if ([ServerType share].type == kTypeHDViet) {
        
        newSource = [SourceHDV initSourceHDV];
        
    } else {
        newSource = [SourceHDO initSourceHDO];
        
    }
    self.dictMainMenu = newSource.dictMainMenu;
    self.dictLeftMenu = newSource.dictLeftMenu;
    
    [self checkSourceMovie:lastListMovie andTableView:tbvListMovie];
    ProgressBarShowLoading(kLoading);
    [self getListMovieShowOnBanner:^(BOOL success, NSMutableArray *array) {
        ProgressBarDismissLoading(kEmptyString);
        completion(success, array);
    }];
}

/*
 * Check source
 */
- (void)checkSourceMovie:(NSInteger)lastListMovie andTableView:(UITableView *)tbvListMovie {
    __block NSInteger last = lastListMovie;
    
    // HDViet
    if ([ServerType share].type == kTypeHDViet) {
        // HDViet
        DLOG(@"Total menu : %d", (int)self.dictMainMenu.allKeys.count);
        
        for (int i = 0; i < self.dictMainMenu.allKeys.count; i++) {
            [[DataAccess share] checkExistDataMovieWithGenre:stringFromInteger([MovieSearch share].genreMovie) andTag:[Utilities sortArrayFromDict:self.dictMainMenu][i] andPage:kPageDefault completionBlock:^(BOOL success, NSMutableArray *array) {
                if (success) {
                    last += 1;
                    
                    [self lastList:last andTableView:tbvListMovie];
                }
                else {
                    ProgressBarShowLoading(kLoading);
                    [[ManageAPI share] loadListMovieAPI:kGenrePhimLe tag:[Utilities sortArrayFromDict:self.dictMainMenu][i] andPage:kPageDefault];
                    [[ManageAPI share] loadListMovieAPI:kGenrePhimBo tag:[Utilities sortArrayFromDict:self.dictMainMenu][i] andPage:kPageDefault];
                }
            }];
        }
        
        lastListMovie = last;
        
    } else {
        // HDOnline
        for (int i = 0; i < self.dictMainMenu.allKeys.count; i++) {
            ProgressBarShowLoading(kLoading);
            NSString *urlListMovie = [NSString stringWithFormat:self.dictMainMenu.allKeys[i],0, [UserHDO share].accessToken];
            [[ManageAPI share] loadListMovieHDOAPI:urlListMovie andKey:self.dictMainMenu.allKeys[i]];
        }
    }

}

/*
 * Check request in last list
 */
- (void)lastList:(NSInteger)lastListMovie andTableView:(UITableView *)tbvListMovie {
    // Check last list category
    if ([Utilities isLastListCategory:self.dictMainMenu andCurrentIndex:lastListMovie andLoop:YES]) {
        [tbvListMovie reloadData];
    }
}

/*
 * Request refresh list movie
 */
- (void)requestRefreshListMovie {
    
    if ([ServerType share].type == kTypeHDViet) {
        DLOG(@"Refresh menu : %d", (int)self.dictMainMenu.allKeys.count);
        
        for (int i = 0; i < self.dictMainMenu.allKeys.count; i++) {
            
            // Not exist - Request server to get list
            [[ManageAPI share] loadListMovieAPI:kGenrePhimLe tag:[Utilities sortArrayFromDict:self.dictMainMenu][i] andPage:kPageDefault];
            [[ManageAPI share] loadListMovieAPI:kGenrePhimBo tag:[Utilities sortArrayFromDict:self.dictMainMenu][i] andPage:kPageDefault];
        }
    } else {
        // HDOnline
        for (int i = 0; i < self.dictMainMenu.allKeys.count; i++) {
            ProgressBarShowLoading(kLoading);
            NSString *urlListMovie = [NSString stringWithFormat:self.dictMainMenu.allKeys[i],0, [User share].accessToken];
            [[ManageAPI share] loadListMovieHDOAPI:urlListMovie andKey:self.dictMainMenu.allKeys[i]];
        }
    }
}

/*
 * Get list movie show on banner
 */
- (void)getListMovieShowOnBanner:(completionDataBlock)completion {
    if ([ServerType share].type == kTypeHDViet) {
        [[DataAccess share] listMovieLocalForTopOnMainByTag:kShowMovieTop
                                                    andPage:kPageDefault completionBlock:^(BOOL success, NSMutableArray *array) {
                                                        completion(success, array);
                                                    }];
    } else {
        [[DataAccess share] listMovieLocalForTopOnMainHDO:kUrlTopMovieHDO
                                                    andPage:kZero completionBlock:^(BOOL success, NSMutableArray *array) {
                                                        completion(success, array);
                                                    }];
    }
}

/*
 * Load list movie local
 */
- (void)loadListMovieLocal:(NSInteger)section
             andCompletion:(completionDataBlock)completion {
    
    if ([ServerType share].type == kTypeHDO) {
        [[DataAccess share] listMovieLocalHDO:kZero andKey:[Utilities sortArrayFromDict:self.dictMainMenu][section] completionBlock:^(BOOL success, NSMutableArray *array) {
            completion(success, array);
        }];
    } else {
        [[DataAccess share] listMovieLocalByTag:[Utilities sortArrayFromDict:self.dictMainMenu][section]
                                       andGenre:stringFromInteger([MovieSearch share].genreMovie)
                                        andPage:kPageDefault completionBlock:^(BOOL success, NSMutableArray *array) {
                                           completion(success, array);
                                        }];
    }
}

/*
 * Handle load list api success
 */
- (void)loadListAPISuccess:(NSDictionary *)response
                   andLast:(NSInteger)lastListMovie
                andRefresh:(UIRefreshControl *)refreshController
                    andKey:(NSString *)key {
    
    BOOL isHDViet = NO;
    if ([ServerType share].type == kTypeHDViet) {
        // Add list movie to local
        [[DataAccess share] addListMovieToLocal:response];
        isHDViet = YES;

    } else {
        isHDViet = NO;
        [[DataAccess share] addListMovieToLocalHDO:response withKey:key];
        // Check last list category
        
    }
    
    if ([Utilities isLastListCategory:self.dictMainMenu andCurrentIndex:lastListMovie andLoop:isHDViet]) {
        // Last list loaded
        ProgressBarDismissLoading(kEmptyString);
        lastListMovie = 0;
        [refreshController endRefreshing];
    } else {
        lastListMovie += 1;
    }
}

/*
 * Show episode on detail cell
 */
- (void)showEpisodeOnDetailCell:(UILabel *)lbEpisode withMovie:(Movie *)movie {
    if ([ServerType share].type == kTypeHDViet) {
        if (movie.episode > 0) {
            lbEpisode.hidden = NO;
            lbEpisode.text = [NSString stringWithFormat:@"Tập %d/%d",(int)movie.sequence,(int)movie.episode];
        } else {
            lbEpisode.hidden = YES;
        }
    } else {
        MovieHDO *movieHDO = (MovieHDO *)movie;
        if (movieHDO.updateEpisode.length > 0) {
            lbEpisode.hidden = NO;
            lbEpisode.text = [NSString stringWithFormat:@"Tập %@",movieHDO.updateEpisode];
        } else {
            lbEpisode.hidden = YES;
        }
    }
}

/*
 * Show image poster on detail cell
 */
- (NSURLRequest *)requestPosterMovie:(Movie *)movie {
    
    NSURL *urlImage = nil;
    if ([ServerType share].type == kTypeHDViet) {
        urlImage = [NSURL URLWithString:[Utilities getStringUrlPoster:movie]];
    } else {
        urlImage = [NSURL URLWithString:movie.poster];
    }
    
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:urlImage
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    return imageRequest;
    
}

/*
 * Show detail information on play controller
 */
- (void)showDetailInforOnPlayController:(UILabel *)lbCast
                                country:(UILabel *)lbCountry
                                   plot:(UITextView *)lbPlot
                               tagMovie:(UILabel *)lbTagMovie
                            releaseDate:(UILabel *)lbReleaseDate
                               andMovie:(Movie *)movie {
    if ([ServerType share].type == kTypeHDViet) {
        MovieHDV *movieHDV = (MovieHDV *)movie;
        lbCountry.text = movieHDV.country;
        lbCast.text = movie.cast;
        lbPlot.text = movie.plotVI;
        lbReleaseDate.text = movie.releaseDate;
        lbTagMovie.text = movie.category;
    } else {
        MovieHDO *movieHDO = (MovieHDO *)movie;
        lbCountry.text = kEmptyString;
        lbCast.text = kEmptyString;
        lbPlot.text = movieHDO.plotVI;
        lbReleaseDate.text = movieHDO.releaseDate;
        lbTagMovie.text = movieHDO.category;
    }
    
    
    
    
}

@end

@implementation SourceHDO

+ (SourceHDO *)initSourceHDO {
    SourceHDO *newSource = [[SourceHDO alloc] init];
    newSource.dictMainMenu = kDicMainMenuHDO;
    newSource.dictLeftMenu = kDicLeftMenuHDO;
    return newSource;
}

@end

@implementation SourceHDV

+ (SourceHDV *)initSourceHDV {
    SourceHDV *newSource = [[SourceHDV alloc] init];
    newSource.dictMainMenu = getDictTitleMenu([MovieSearch share].genreMovie);
    newSource.dictLeftMenu = kDicLeftMenu;
    return newSource;
}

- (void)loadListMovieAPIHDV {
    [[ManageAPI share] loadListMovieAPI:[MovieSearch share].genreMovie
                                    tag:self.tagMovie
                                andPage:self.page];
}

@end