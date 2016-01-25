//
//  User.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

// Property
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *displayName;

// Init user from json
+ (User *)userFromJSON:(NSDictionary *)json;

@end
