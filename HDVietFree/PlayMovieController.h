//
//  PlayMovieController.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/29/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface PlayMovieController : MPMoviePlayerViewController

+ (PlayMovieController *)share;

@property (strong, nonatomic) Movie *aMovie;

/*
 * Play media controller
 */
- (void)playMovieWithController:(nonnull UIViewController *)controller;

@end
