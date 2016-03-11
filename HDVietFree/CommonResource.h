//
//  CommonResource.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MPMoviePlayerViewController;
@class FilmController;

@interface CommonResource : NSObject

/**
 * Search image
 */
extern NSString *const kSearchIcon;

/**
 * No image
 */
extern NSString *const kNoImage;

/**
 * No image
 */
extern NSString *const kNoBannerImage;

/**
 * Left menu
 */
extern NSString *const kLeftMenu;

/**
 * Left menu
 */
extern NSString *const kBackgroundImage;

/**
 * Delete image
 */
extern NSString *const kDeleteImage;

/*
 * Set pair view controller
 */
extern PlayController *kPlayViewController;

/*
 * Set pair view controller
 */
extern FilmController *kFilmViewController;

extern MPMoviePlayerViewController *kMoviePlayer;

extern UIViewController *kViewControllerPlay;

@end
