//
//  User.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <Foundation/Foundation.h>

//*****************************************************************************
#pragma mark -
#pragma mark - ** User**
@interface User : NSObject

+ (User *)share;

// Property
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *accessToken;

+ (User *)userFromJSON:(NSDictionary *)json;

@end

//*****************************************************************************
#pragma mark -
#pragma mark - ** User HDOnline**
@interface UserHDO : User

+ (UserHDO *)share;

// Init user from json
+ (UserHDO *)userHDOFromJSON:(NSDictionary *)json;
@end

//*****************************************************************************
#pragma mark -
#pragma mark - ** User HDViet**
@interface UserHDV : User

+ (UserHDV *)share;

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *displayName;

// Init user from json
+ (UserHDV *)userHDVFromJSON:(NSDictionary *)json;

@end