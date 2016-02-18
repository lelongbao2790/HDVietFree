//
//  NSObject+Associating.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/18/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "NSObject+Associating.h"

@implementation NSObject (Associating)

- (id)associatedObject
{
    return objc_getAssociatedObject(self, @selector(associatedObject));
}

- (void)setAssociatedObject:(id)associatedObject
{
    objc_setAssociatedObject(self,
                             @selector(associatedObject),
                             associatedObject,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
