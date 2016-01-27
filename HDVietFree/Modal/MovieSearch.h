//
//  MovieSearch.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DBAccess/DBAccess.h>

@interface MovieSearch : DBObject

+ (MovieSearch *)share;

@property (assign, nonatomic) NSInteger genreMovie;
@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) NSString *tagMovie;

@end
