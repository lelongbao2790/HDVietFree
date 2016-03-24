//
//  ServerType.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 3/23/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerType : NSObject

+ (ServerType *)share;

@property (assign, nonatomic) NSInteger type;

/*
 * Check is save token
 */
+ (BOOL)isSaveToken;

@end
