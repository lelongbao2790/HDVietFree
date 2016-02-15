//
//  Utilities.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/21/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Utilities : NSObject

+ (Utilities *)share;

/**
 * fix auto layout for iPhone 5/5S, iPhone 6/6S, iPhone 6/6S Plus
 */
+ (void) fixAutolayoutWithDelegate:(nonnull id /*<UIFixAutolayoutDelegate>*/)delegate;

/**
 * Show iToast message for informing.
 * @param message
 */
+ (void)showiToastMessage:(nonnull NSString *)message;

/*
 * Save image
 */
+ (void)saveImage:(nonnull UIImage*)image withName:(nonnull NSString *)nameImage;

/*
 * Get srt file from url
 */
+ (nonnull NSString*)getDataSubFromUrl:(nonnull NSString*)srtUrl;

/*
 * Load image
 */
+ (nonnull UIImage*)loadImageFromName:(nonnull NSString *)nameImage;

/*
 * Load image
 */
+ (BOOL)isExistImage:(nonnull NSString *)nameImage;

/*
 * Set main page
 */
+ (void)setMainPageSlide;

/*
 * Get year from date
 */
+ (nonnull NSString *)getYearOfDateFromString:(nonnull NSString *)strDate;

/*
 * Get string url poster image
 */
+ (nonnull NSString *)getStringUrlPoster:(nonnull Movie *)movie;

/*
 * Get width of screen
 */
+ (CGFloat)widthOfScreen;

/*
 * Height of screen
 */
+ (CGFloat)heightOfScreen;

// set
- (void)cacheImage:(nonnull UIImage*)image forKey:(nonnull NSString*)key;

// get
- (nonnull UIImage*)getCachedImageForKey:(nonnull NSString*)key;

+ ( NSDictionary * _Nullable )convertNullDictionary:(NSDictionary * _Nullable )dict;

/*
 * Play media controller
 */
+ (void)playMediaLink:(nonnull NSString *)linkPlay
               andSub:(nonnull NSString *)linkSub
        andController:(nonnull UIViewController *)controller;

+ (void)moviePlaybackDidFinish:(NSNotification*)aNotification;

+ (NSArray *)sortArrayFromDict:(NSDictionary *)dict;

@end
