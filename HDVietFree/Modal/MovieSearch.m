//
//  MovieSearch.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "MovieSearch.h"

@implementation MovieSearch
@dynamic genreMovie, page, tagMovie;
+ (MovieSearch *)share {
    static dispatch_once_t once;
    static MovieSearch *share;
    dispatch_once(&once, ^{
        share = [self new];
    });
    return share;
}

- (instancetype) init{
    self = [super init];
    if (self) {
        // Set default
        self.genreMovie = kGenrePhimLe;
        self.page = kPageDefault;
        self.tagMovie = kEmptyString;
    }
    return self;
}


@end
