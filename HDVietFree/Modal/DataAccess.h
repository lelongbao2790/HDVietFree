//
//  DataAccess.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/27/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataAccess : NSObject

/*
 * Singleton
 */
+ (DataAccess *)share;

/*
 * Get list movie local
 */
- (NSMutableArray *)listMovieLocalByTag:(NSString *)tagMovie andGenre:(NSString *)genreMovie andPage:(NSInteger)page;

/*
 * Check exist data
 */
- (BOOL)isExistDataMovieWithGenre:(NSString *)genreMovie andTag:(NSString *)tagMovie andPage:(NSInteger)page;

/*
 * Get movie from Id
 */
- (Movie *)getMovieFromId:(NSString *)movieId;

/*
 * Get relative movie in db
 */
- (NSArray *)getRelativeMovieInDB:(NSString *)movieId;

/*
 * Get movie with release 2015 - 2016
 */
- (NSArray *)getListTopMovieWithReleaseDateInDB;

/*
 * Load list movie api success
 */
- (void)addListMovieToLocal:(NSDictionary *)response;

@end
