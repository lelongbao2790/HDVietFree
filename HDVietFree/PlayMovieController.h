//
//  PlayMovieController.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/29/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface PlayMovieController : MPMoviePlayerViewController

+ (nonnull PlayMovieController *)share;

@property (strong, nonatomic) Movie *aMovie;
@property (assign, nonatomic) NSInteger epiNumber;
@property (assign, nonatomic) NSTimeInterval timePlayMovie;

/*
 * Play media controller
 */
- (void)playMovieWithController:(nonnull UIViewController *)controller;

@end
