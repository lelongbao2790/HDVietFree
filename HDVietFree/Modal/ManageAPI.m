//
//  ManageAPI.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "ManageAPI.h"

@implementation ManageAPI

/*
 * Singleton
 */
+ (ManageAPI *)share {
    static dispatch_once_t once;
    static ManageAPI *share;
    dispatch_once(&once, ^{
        share = [self new];
    });
    return share;
}

/*
 * login API
 */
- (void)loginAPI:(NSString *)userName andPass:(NSString *)password {
    NSString *strUrl = [NSString stringWithFormat:kUrlLogin, userName, [password MD5]];
    DLOG(@"Login with url:%@", strUrl);
    [[DataManager shared] postLoginWithUrl:strUrl];
}

/*
 * Get category API
 */
- (void)getCategoryAPI {
    
}


@end
