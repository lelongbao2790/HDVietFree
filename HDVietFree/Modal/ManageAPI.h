//
//  ManageAPI.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManageAPI : NSObject

/*
 * Singleton
 */
+ (ManageAPI *)share;

/*
 * login API
 */
- (void)loginAPI:(NSString *)userName andPass:(NSString *)password;

/*
 * Load list movie API
 */
- (void)loadListMovieAPI:(NSInteger)genre tag:(NSString *)tagMovie andPage:(NSInteger)page;

/*
 * Load detail information movie API
 */
- (void)loadDetailInfoMovieAPI:(Movie*)movie;

/*
 * Load link play movie
 */
- (void)loadLinkToPlayMovie:(Movie*)movie andEpisode:(NSInteger)episode;

/*
 * Search movie
 */
- (void)searchMovieWithKeyword:(NSString *)keyword;

@end
