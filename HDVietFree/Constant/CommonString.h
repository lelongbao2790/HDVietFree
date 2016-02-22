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
 * Search cell identifier
 */
extern NSString *const kSearchCellIdentifier;

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

/**
 * Relative movie
 */
extern NSString *const kSearchMovieTitle;

/**
 * Relative movie
 */
extern NSString *const kSearchMovie;

/**
 * Relative movie
 */
extern NSString *const kUpdateMovieSuccess;

/**
 * Error play film
 */
extern NSString *const kErrorPlayMovie;

/**
 * Error play film
 */
extern NSString *const kInvalidSession;

/**
 * Server overload
 */
extern NSString *const kServerOverload;

/**
 * Error play film
 */
extern NSString *const k400BadRequestString;

/**
 * Error 502
 */
extern NSString *const k502BadRequestString;

/**
 * Error 500
 */
extern NSString *const k500BadRequestString;

/**
 * Log out
 */
extern NSString *const kLogOut;

/**
 * Update
 */
extern NSString *const kUpdateData;

/**
 * Update
 */
extern NSString *const kPhimLeString;

/**
 * Update
 */
extern NSString *const kPhimBoString;

/**
 * Update
 */
extern NSString *const kReportFail;

/**
 * Update
 */
extern NSString *const kReportSuccess;

/**
 * Bug description
 */
extern NSString *const kBugDescription;

/**
 * Bug description
 */
extern NSString *const kReportString ;

@end
