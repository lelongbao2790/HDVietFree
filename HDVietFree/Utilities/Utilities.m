//
//  Utilities.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/21/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "Utilities.h"
#define kTimeDuration 300

@implementation Utilities

/**
 * Show iToast message for informing.
 * @param message
 */
+ (void)showiToastMessage:(nonnull NSString *)message
{
    
    iToastSettings *theSettings = [iToastSettings getSharedSettings];
    theSettings.duration = kTimeDuration;
    
    // Prevent crash with null string
    if (message == (id)[NSNull null]) {
        message = kEmptyString;
    }
    
    [[[[iToast makeText:message]
       setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
}

@end
