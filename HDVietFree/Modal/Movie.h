//
//  Movie.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DBAccess/DBAccess.h>

@interface Movie : DBObject

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
@property (strong, nonatomic) NSString *tagMovie;
@property (strong, nonatomic) NSString *genreMovie;
@property (strong, nonatomic) NSString *bannerMovie;
@property (strong, nonatomic) NSString *backdrop;
@property (strong, nonatomic) NSString *relativeMovie;
@property (strong, nonatomic) NSString *backdrop945530;
@property (strong, nonatomic) NSString *category;
@property (assign, nonatomic) NSInteger pageNumber;
@property (assign, nonatomic) NSInteger totalRecord;
@property (strong, nonatomic) NSString *urlLinkPlayMovie;
@property (strong, nonatomic) NSString *urlLinkSubtitleMovie;

// Init movie from json
+ (Movie *)detailRelativeMovieFromJson:(NSDictionary *)json;

// Init movie from json
+ (Movie *)detailListMovieFromJSON:(NSDictionary *)json withTag:(NSString *)tagMovie andGenre:(NSString *)genreMovie;

// Update information movie
+ (void)updateInformationMovieFromJSON:(NSDictionary *)json andMovie:(Movie *)movie;

// Init movie from json search
+ (Movie *)initMovieFromJSONSearch:(NSDictionary *)json;

@end
