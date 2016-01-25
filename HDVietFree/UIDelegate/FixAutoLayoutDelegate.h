//
//  FixAutoLayoutDelegate.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/21/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#ifndef FixAutoLayoutDelegate_h
#define FixAutoLayoutDelegate_h

#import <UIKit/UIKit.h>

@protocol FixAutolayoutDelegate <NSObject>

@optional

- (void)fixAutolayoutFor35;
- (void)fixAutolayoutFor40;
- (void)fixAutolayoutFor47;
- (void)fixAutolayoutFor55;
- (void)fixAutolayoutForIpad;

@end
#endif /* FixAutoLayoutDelegate_h */
