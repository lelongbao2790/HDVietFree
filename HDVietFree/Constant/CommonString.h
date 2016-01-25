//
//  CommonString.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonString : NSObject

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
extern NSString *const kCollectionTopMenuIdentifier;

/**
 * Main Controller : Detail movie
 */
extern NSString *const kCollectionDetailMovieIdentifier;

/**
 * NSUserDefault : User name
 */
extern NSString *const kUserNameStore;

/**
 * NSUserDefault : Password
 */
extern NSString *const kPasswordStore;

@end
