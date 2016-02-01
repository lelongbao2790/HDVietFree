//
//  NSString+MD5.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/22/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

- (NSString *)MD5;

- (BOOL) containsString: (NSString*) substring;
- (NSString *)encodeNSUTF8: (NSString*) link;

@end
