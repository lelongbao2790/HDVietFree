//
//  DataAccess.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/27/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^completionDataBlock)(BOOL success, NSMutableArray * array);

@interface DataAccess : NSObject

/*
 * Singleton
 */
+ (DataAccess *)share;

/*
 * Get list movie local
 */
- (NSArray *)listMovieLocalByTag2:(NSString *)tagMovie andGenre:(NSString *)genreMovie andPage:(NSInteger)page;

/*
 * Get list movie local
 */
- (void)listMovieLocalByTag:(NSString *)tagMovie andGenre:(NSString *)genreMovie andPage:(NSInteger)page completionBlock:(completionDataBlock)completionBlock;

/*
 * Check exist data
 */
- (void)checkExistDataMovieWithGenre:(NSString *)genreMovie andTag:(NSString *)tagMovie andPage:(NSInteger)page completionBlock:(completionDataBlock)completionBlock;

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
