//
//  CommonString.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonString : NSObject
#define kLoadImageInBackground "backgroundDownloadImage"

/**
 * Empty String
 */
extern NSString *const kEmptyString;

/**
 * Slide menu Controller : Table view identifier
 */
extern NSString *const kTableViewLeftMenuIdentifier;

/**
 * Main Controller : Collection view top menu
 */
extern NSString *const kTableViewMoviedentifier;

/**
 * Main Controller : Table view identifier
 */
extern NSString *const kPlayMovieCellIdentifier;

/**
 * Main Controller : Detail movie
 */
extern NSString *const kCollectionDetailMovieIdentifier;

/**
 * Main Controller : top movie
 */
extern NSString *const kCollectionTopMainIdentifier;

/**
 * Loading
 */
extern NSString *const kLoading;

/**
 * Genre 1: PhimLe
 */
extern NSString *const kPhimLe;

/**
 * Genre 2: Phimbo
 */
extern NSString *const kPhimBo;

/**
 * Name database
 */
extern NSString *const kNameDatabase;

/**
 * Relative movie
 */
extern NSString *const kRelativeMovie;

@end
