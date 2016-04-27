//
//  DataAccess.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/27/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "DataAccess.h"

@implementation DataAccess

/*
 * Singleton
 */
+ (DataAccess *)share {
    static dispatch_once_t once;
    static DataAccess *share;
    dispatch_once(&once, ^{
        share = [self new];
    });
    return share;
}

/*
 * Get list movie local
 */
- (NSArray *)listMovieLocalByTag2:(NSString *)tagMovie andGenre:(NSString *)genreMovie andPage:(NSInteger)page {
    NSMutableArray *listMovieLocal = [[NSMutableArray alloc] init];
    DBResultSet* r = [[[Movie query] whereWithFormat:@"tagMovie = %@ and genreMovie = %@ and pageNumber = %d", tagMovie, genreMovie, (int)page]
                      fetch];
    if (r.count > 0) {
        for (Movie* newMovie in r) {
            [listMovieLocal addObject:newMovie];
        }
        
        return listMovieLocal;
        
    } else {
        return nil;
    }
}

/*
 * Get list channel
 */
- (NSArray *)getListChannelLocal {
    NSMutableArray *listChannel = [[NSMutableArray alloc] init];
    DBResultSet* r = [[TVChannel query] fetch];
    if (r.count > 0) {
        for (TVChannel* newChannel in r) {
            [listChannel addObject:newChannel];
        }
        
        return listChannel;
        
    } else {
        return nil;
    }
}

/*
 * Get list movie
 */
- (NSArray *)getAllMovie {
    NSMutableArray *listMovie = [[NSMutableArray alloc] init];
    DBResultSet* r = [[Movie query] fetch];
    if (r.count > 0) {
        for (Movie* movie in r) {
            [listMovie addObject:movie];
        }
        
        return listMovie;
        
    } else {
        return nil;
    }
}

/*
 * Get list movie local
 */
- (void)listMovieLocalByTag:(NSString *)tagMovie andGenre:(NSString *)genreMovie andPage:(NSInteger)page completionBlock:(completionDataBlock)completionBlock {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        // Download
        NSMutableArray *listMovieLocal = [[NSMutableArray alloc] init];
        DBResultSet* r = [[[Movie query] whereWithFormat:@"tagMovie = %@ and genreMovie = %@ and pageNumber = %d", tagMovie, genreMovie, (int)page]
                          fetch];
        if (r.count > 0) {
            for (Movie* newMovie in r) {
                [listMovieLocal addObject:newMovie];
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(YES, listMovieLocal);
                }
            });
            
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(NO, listMovieLocal);
                }
            });
            
        }
    });
}

/*
 * Get list movie local
 */
- (void)listMovieLocalForTopOnMainByTag:(NSString *)tagMovie andPage:(NSInteger)page completionBlock:(completionDataBlock)completionBlock {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        // Download
        NSMutableArray *listMovieLocal = [[NSMutableArray alloc] init];
        NSString *genre1 = stringFromInteger(3);
        DBResultSet* r = [[[Movie query] whereWithFormat:@"tagMovie = %@ and genreMovie < %@ and pageNumber = %d", tagMovie, genre1, (int)page]
                          fetch];
        if (r.count > 0) {
            for (Movie* newMovie in r) {
                [listMovieLocal addObject:newMovie];
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(YES, listMovieLocal);
                }
            });
            
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(NO, listMovieLocal);
                }
            });
            
        }
    });
}

/*
 * Check exist data
 */
- (void)checkExistDataMovieWithGenre:(NSString *)genreMovie andTag:(NSString *)tagMovie andPage:(NSInteger)page completionBlock:(completionDataBlock)completionBlock {
    
    // Using GCD to get list db local
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        
        DBResultSet* r = [[[Movie query]
                           whereWithFormat:@"genreMovie = %@ and tagMovie = %@ and pageNumber = %d", genreMovie, tagMovie, (int)page]
                          fetch];
        
        if (r.count > 0) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(YES, nil);
                }
            });
            
        }
        else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(NO, nil);
                }
            });
            
        }

        
    });
}

/*
 * Get movie from Id
 */
- (Movie *)getMovieFromId:(NSString *)movieId; {
    Movie *movieObj = nil;
    DBResultSet* r = [[[Movie query]
                       whereWithFormat:@"movieID = %@", movieId]
                      fetch];
    
    if (r.count > 0)
        for (Movie *aMovie in r) {
            movieObj = aMovie;
        }
    else
        movieObj = nil;
    
    return movieObj;
}

/*
 * Get relative movie in db
 */
- (NSArray *)getRelativeMovieInDB:(NSString *)movieId {
    DBResultSet* r = [[[[Movie query]
                       whereWithFormat:@"relativeMovie = %@", movieId]
                       orderBy:@"movieID"]
                      fetch];
    
    if (r.count > 0) {
        return r;
    }
    else
        return nil;
}

/*
 * Get relative movie in db
 */
- (NSArray *)getAllSeasonMovieInDB:(NSString *)movieId {
    DBResultSet* r = [[[Movie query]
                        whereWithFormat:@"seasonId = %@", movieId]
                       fetch];
    
    if (r.count > 0) {
        return r;
    }
    else
        return nil;
}

/*
 * Get movie with release 2015 - 2016
 */
- (NSArray *)getListTopMovieWithReleaseDateInDB {

    NSMutableArray *listTopMovie = [[NSMutableArray alloc] init];
    DBResultSet* r = [[[[Movie query]
                       whereWithFormat:@"genreMovie = %@", stringFromInteger([MovieSearch share].genreMovie)]
                       orderBy:@"movieID"]
                      fetch];
    if (r.count > 0) {
        for (Movie *aMovie in r) {
            if ([aMovie.releaseDate containsString:k2015] ||
                [aMovie.releaseDate containsString:k2016]) {
                [listTopMovie addObject:aMovie];
            }
        }
    }
    else
        listTopMovie = nil;
    return listTopMovie;
}

/*
 * Load list movie api success
 */
- (void)addListMovieToLocal:(NSDictionary *)response {
    // Get list movie from response
    NSArray *listResponse = dictToArray(response);
    NSArray *listData = listResponse[kListDataPosition];
    
    // Get detail movie and init object movie
    for (NSDictionary *dictObjectMovie in listData) {
        Movie *newMovie = nil;
        newMovie = [Movie detailListMovieFromJSON:dictObjectMovie
                                          withTag:listResponse[kTagMoviePosition]
                                         andGenre:stringFromInteger(numberToInteger(listResponse[kGenreNumberPosition]))];
        newMovie.pageNumber = numberToInteger(listResponse[kPageResponsePosition]);
        newMovie.totalRecord = numberToInteger(listResponse[kTotalRecordPosition]);
        [newMovie commit];
    }
}

@end
