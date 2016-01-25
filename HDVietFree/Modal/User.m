//
//  User.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "User.h"

@implementation User

// Init user from json
+ (User *)userFromJSON:(NSDictionary *)json {
    User *newUser = [[User alloc] init];
    newUser.userId = [json objectForKey:kUserId];
    newUser.userName = [json objectForKey:kUserName];
    newUser.email = [json objectForKey:kEmail];
    newUser.accessToken = [json objectForKey:kAccessToken];
    newUser.displayName = [json objectForKey:kDisplayName];
    return newUser;
}

@end
