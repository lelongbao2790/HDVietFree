//
//  UIColor+HexColor.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

/**
 * Color with hex tring
 */
+ (UIColor *)colorWithHexString:(NSString *)hex;

@end
