//
//  Movie.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryFilm.h"

@interface Movie : NSObject

// Property
@property (strong, nonatomic) NSString *movieID;
@property (strong, nonatomic) NSString *movieName;
@property (strong, nonatomic) NSString *knownAs;
@property (strong, nonatomic) NSString *trailer;
@property (strong, nonatomic) NSString *poster124x184;
@property (strong, nonatomic) NSString *poster;
@property (assign, nonatomic) NSInteger sequence;
@property (assign, nonatomic) NSInteger currentSeason;
@property (assign, nonatomic) NSInteger episode;
@property (assign, nonatomic) NSInteger runtime;
@property (strong, nonatomic) NSString *cast;
@property (strong, nonatomic) NSString *plotVI;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *releaseDate;
@property (strong, nonatomic) CategoryFilm *categoryFilm;

// Init movie from json
+ (Movie *)movieFromJSON:(NSDictionary *)json;

@end
