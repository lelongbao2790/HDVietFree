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
- (NSMutableArray *)listMovieLocalByTag:(NSString *)tagMovie andGenre:(NSString *)genreMovie {
    NSMutableArray *listMovieLocal = [[NSMutableArray alloc] init];
    DBResultSet* r = [[[Movie query]
                       whereWithFormat:@"tagMovie = %@ and genreMovie = %@", tagMovie, genreMovie]
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
 * Check exist data
 */
- (BOOL)isExistDataMovieWithGenre:(NSString *)genreMovie andTag:(NSString *)tagMovie {
    DBResultSet* r = [[[Movie query]
                       whereWithFormat:@"genreMovie = %@ and tagMovie = %@", genreMovie, tagMovie]
                      fetch];
    
    if (r.count > 0)
        return YES;
    else
        return NO;
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
    DBResultSet* r = [[[Movie query]
                       whereWithFormat:@"relativeMovie = %@", movieId]
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
    DBResultSet* r = [[[Movie query]
                       whereWithFormat:@"genreMovie = %@", stringFromInteger([MovieSearch share].genreMovie)]
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

@end
