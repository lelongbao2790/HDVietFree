//
//  Movie.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

+ (Movie *)movieFromJSON:(NSDictionary *)json;

@end
