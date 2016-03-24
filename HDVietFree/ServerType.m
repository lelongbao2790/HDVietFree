//
//  ServerType.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 3/23/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "ServerType.h"

@implementation ServerType

+ (ServerType *)share {
    static dispatch_once_t once;
    static ServerType *share;
    dispatch_once(&once, ^{
        share = [self new];
    });
    return share;

}

- (instancetype) init{
    self = [super init];
    if (self) {
        // Set default
        self.type = kTypeHDViet;
    }
    return self;
}

/*
 * Check is save token
 */
+ (BOOL)isSaveToken {
    if ([ServerType share].type == kTypeHDViet) {
        NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken];
        
        if (accessToken) {
            [UserHDV share].accessToken = accessToken;
            [UserHDV share].userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
            return YES;
        } else {
            return NO;
        }
    } else {
        NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessTokenHDO];
        
        if (accessToken) {
            [UserHDO share].accessToken = accessToken;
            [UserHDO share].userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserNameHDO];
            return YES;
        } else {
            return NO;
        }
    }

}

@end
