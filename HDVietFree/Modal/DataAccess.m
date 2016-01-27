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

@end
