//
//  User.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "User.h"

//*****************************************************************************
#pragma mark -
#pragma mark - ** User **
@implementation User

+ (User *)share {
    static dispatch_once_t once;
    static User *share;
    dispatch_once(&once, ^{
        share = [self new];
    });
    return share;
}

+ (User *)userFromJSON:(NSDictionary *)json {
    User *newUser = nil;
    
    if ([ServerType share].type == kTypeHDViet) {
        newUser = [UserHDV userHDVFromJSON:json];
        [[NSUserDefaults standardUserDefaults] setObject:newUser.accessToken forKey:kAccessToken];
        [[NSUserDefaults standardUserDefaults] setObject:newUser.userName forKey:kUserName];
    } else {
        newUser = [UserHDO userHDOFromJSON:json];
        [[NSUserDefaults standardUserDefaults] setObject:newUser.accessToken forKey:kAccessTokenHDO];
        [[NSUserDefaults standardUserDefaults] setObject:newUser.userName forKey:kUserNameHDO];
    }
    return newUser;
}

@end

//*****************************************************************************
#pragma mark -
#pragma mark - ** User HDOnline**
/*
 * User HDOnline
 */
@implementation UserHDO

+ (UserHDO *)share {
    static dispatch_once_t once;
    static UserHDO *share;
    dispatch_once(&once, ^{
        share = [self new];
    });
    return share;
}

// Init user from json
+ (UserHDO *)userHDOFromJSON:(NSDictionary *)json {
    NSDictionary *dictUser = [json objectForKey:kUser];
    
    UserHDO *newUser = [UserHDO share];
    newUser.userId = [dictUser objectForKey:kDocMovieId];
    newUser.userName = [dictUser objectForKey:kUserNameHDOString];
    newUser.accessToken = [json objectForKey:kToken];
    return newUser;
}

@end

//*****************************************************************************
#pragma mark -
#pragma mark - ** User HDViet**
/*
 * User HDViet
 */
@implementation UserHDV

+ (UserHDV *)share {
    static dispatch_once_t once;
    static UserHDV *share;
    dispatch_once(&once, ^{
        share = [self new];
    });
    return share;
}

// Init user from json
+ (UserHDV *)userHDVFromJSON:(NSDictionary *)json {
    UserHDV *newUser = [UserHDV share];
    newUser.userId = [json objectForKey:kUserId];
    newUser.userName = [json objectForKey:kUserName];
    newUser.email = [json objectForKey:kEmail];
    newUser.accessToken = [json objectForKey:kAccessToken];
    newUser.displayName = [json objectForKey:kDisplayName];
    return newUser;
}

@end
