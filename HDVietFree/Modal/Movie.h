//
//  Movie.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DBAccess/DBAccess.h>

//*****************************************************************************
#pragma mark -
#pragma mark - ** Movie **
@interface Movie : DBObject

// Property
@property (strong, nonatomic) NSString *movieID;
@property (strong, nonatomic) NSString *movieName;
@property (strong, nonatomic) NSString *trailer;
@property (assign, nonatomic) NSInteger episode;
@property (assign, nonatomic) NSInteger runtime;
@property (strong, nonatomic) NSString *cast;
@property (strong, nonatomic) NSString *plotVI;
@property (strong, nonatomic) NSString *releaseDate;
@property (strong, nonatomic) NSString *tagMovie;
@property (strong, nonatomic) NSString *genreMovie;
@property (strong, nonatomic) NSString *bannerMovie;
@property (strong, nonatomic) NSString *backdrop;
@property (assign, nonatomic) NSInteger pageNumber;
@property (assign, nonatomic) NSInteger totalRecord;
@property (strong, nonatomic) NSString *urlLinkPlayMovie;
@property (strong, nonatomic) NSString *urlLinkSubtitleMovie;
@property (strong, nonatomic) NSString *imdbRating;
@property (strong, nonatomic) NSString *seasonId;
@property (assign, nonatomic) NSTimeInterval timePlay;
@property (assign, nonatomic) NSInteger epiNumber;
@property (strong, nonatomic) NSString *category;
@property (assign, nonatomic) NSInteger sequence;
@property (strong, nonatomic) NSString *poster;

@end
//*****************************************************************************
#pragma mark -
#pragma mark - ** Movie HDV **
@interface MovieHDV : Movie

// Property
@property (strong, nonatomic) NSString *knownAs;
@property (strong, nonatomic) NSString *poster124x184;
@property (assign, nonatomic) NSInteger currentSeason;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *relativeMovie;
@property (strong, nonatomic) NSString *backdrop945530;


// Init movie from json
+ (MovieHDV *)detailRelativeMovieFromJson:(NSDictionary *)json;

// Init movie from json
+ (MovieHDV *)detailListMovieFromJSON:(NSDictionary *)json withTag:(NSString *)tagMovie andGenre:(NSString *)genreMovie;

// Update information movie
+ (void)updateInformationMovieFromJSON:(NSDictionary *)json andMovie:(MovieHDV *)movie;

// Init movie from json search
+ (MovieHDV *)initMovieFromJSONSearch:(NSDictionary *)json;

// Init season movie
+ (void)initSeasonMovieFromJSONSearch:(NSDictionary *)json andMovie:(MovieHDV *)oldMovie;

@end

//*****************************************************************************
#pragma mark -
#pragma mark - ** Movie HDO **
@interface MovieHDO : Movie
@property (strong, nonatomic) NSString *slug;
@property (strong, nonatomic) NSString *keyMovie;
@property (strong, nonatomic) NSString *updateEpisode;

+ (MovieHDO *)initMovieFromJSON:(NSDictionary *)json withKey:(NSString *)key;

@end
