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
- (NSMutableArray *)listMovieLocalByTag:(NSString *)tagMovie andGenre:(NSString *)genreMovie;

/*
 * Check exist data
 */
- (BOOL)isExistDataMovieWithGenre:(NSString *)genreMovie andTag:(NSString *)tagMovie;


@end
