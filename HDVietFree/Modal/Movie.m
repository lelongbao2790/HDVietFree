//
//  Movie.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "Movie.h"

@implementation Movie
@dynamic movieID, movieName, knownAs, trailer, poster, poster124x184, sequence, currentSeason, episode, runtime, cast, plotVI, country, releaseDate, tagMovie, genreMovie, bannerMovie, backdrop, backdrop945530, relativeMovie, category, pageNumber, totalRecord, urlLinkPlayMovie, urlLinkSubtitleMovie, imdbRating;

+ (DBIndexDefinition *)indexDefinitionForEntity {
    
    /* if you return an index definition object, then DBAccess will maintain the indexed based on this */
    
    DBIndexDefinition* idx = [DBIndexDefinition new];
    [idx addIndexForProperty:@"movieName" propertyOrder:DBIndexSortOrderAscending];
    return idx;
    
}

// Init movie from json
+ (Movie *)detailRelativeMovieFromJson:(NSDictionary *)json {
    Movie *newMovie = [Movie new];
    newMovie.movieID = [Utilities nullToObject:json key:kMovieId andType:kTypeString];
    newMovie.movieName = [Utilities nullToObject:json key:kMovieRelativeName andType:kTypeString];
    newMovie.knownAs = [Utilities nullToObject:json key:kKnownAs andType:kTypeString];
    newMovie.poster124x184 = [Utilities nullToObject:json key:kPoster124184 andType:kTypeString];
    newMovie.poster = [Utilities nullToObject:json key:kPosterLink andType:kTypeString];
    newMovie.sequence = [[json objectForKey:kSequence] integerValue];
    newMovie.episode = [[json objectForKey:kEpisode] integerValue];
    [newMovie commit];
    return newMovie;
}

// Init movie from json
+ (Movie *)detailListMovieFromJSON:(NSDictionary *)json withTag:(NSString *)tagMovie andGenre:(NSString *)genreMovie {
    Movie *newMovie = [Movie new];
    newMovie.movieID = [json objectForKey:kMovieId];
    newMovie.movieName = [Utilities nullToObject:json key:kMovieName andType:kTypeString];
    newMovie.knownAs = [Utilities nullToObject:json key:kKnownAs andType:kTypeString];
    newMovie.trailer = [Utilities nullToObject:json key:kTrailer andType:kTypeString];
    newMovie.poster = [Utilities nullToObject:json key:kNewPoster andType:kTypeString];
    newMovie.sequence = [[json objectForKey:kSequence] integerValue];
    newMovie.currentSeason = [[json objectForKey:kCurrentSeason] integerValue];
    newMovie.episode = [[json objectForKey:kEpisode] integerValue];
    newMovie.cast = [Utilities nullToObject:json key:kCast andType:kTypeString];
    newMovie.plotVI = [Utilities nullToObject:json key:kPlotVI andType:kTypeString];
    newMovie.country = [Utilities nullToObject:json key:kCountry andType:kTypeString];
    newMovie.bannerMovie = [Utilities nullToObject:json key:kBannerFilm andType:kTypeString];
    newMovie.backdrop = [Utilities nullToObject:json key:kBackDrop andType:kTypeString];
    newMovie.imdbRating = [NSString stringWithFormat:@"%.02f",[[json objectForKey:kImdbRating] floatValue]];
    newMovie.tagMovie = tagMovie;
    newMovie.genreMovie = genreMovie;
    return newMovie;
}

// Update information movie
+ (void)updateInformationMovieFromJSON:(NSDictionary *)json andMovie:(Movie *)movie {
    
    // Information
    movie.movieID = movie.movieID;
    movie.movieName = [Utilities nullToObject:json key:kMovieName andType:kTypeString];
    movie.knownAs = [Utilities nullToObject:json key:kKnownAs andType:kTypeString];
    movie.trailer = [Utilities nullToObject:json key:kTrailer andType:kTypeString];
    movie.sequence = [[json objectForKey:kSequence] integerValue];
    movie.currentSeason = [[json objectForKey:kCurrentSeason] integerValue];
    movie.episode = [[json objectForKey:kEpisode] integerValue];
    movie.cast = [Utilities nullToObject:json key:kCast andType:kTypeString];
    movie.plotVI = [Utilities nullToObject:json key:kPlotVI andType:kTypeString];
    movie.country = [Utilities nullToObject:json key:kCountry andType:kTypeString];
    movie.releaseDate = [Utilities nullToObject:json key:kReleaseDate andType:kTypeString];
    movie.genreMovie = stringFromInteger([MovieSearch share].genreMovie);
    movie.runtime = [[json objectForKey:kRuntime] integerValue];
    movie.imdbRating = [NSString stringWithFormat:@"%.02f",[[json objectForKey:kImdbRating] floatValue]];
    // Update category
    NSArray *listCategory = (NSArray *)[Utilities nullToObject:json key:kCategoryFilm andType:kTypeArray];
    movie.category = kEmptyString;
    for (NSDictionary *category in listCategory) {
        if ([movie.category isEqualToString:kEmptyString]) {
            movie.category = [NSString stringWithFormat:@"%@",[category objectForKey:kCategoryName]];
        } else {
            movie.category = [NSString stringWithFormat:@"%@, %@", movie.category, [category objectForKey:kCategoryName]];
        }
        
    }
    
    NSArray *listRelativeFromJson = (NSArray *)[Utilities nullToObject:json key:kRelative andType:kTypeArray];
    
    for (NSDictionary *dictMovie in listRelativeFromJson) {
        Movie *movieFromLocal = [[DataAccess share] getMovieFromId:[dictMovie objectForKey:kMovieId]];
        if (movieFromLocal == nil) {
            // Movie not exist in local
            Movie *aMovie = [Movie detailRelativeMovieFromJson:dictMovie];
            aMovie.relativeMovie = movie.movieID;
            [aMovie commit];
            
        } else {
            // Movie exist in local
            movieFromLocal.relativeMovie = movie.movieID;
            [movieFromLocal commit];
        }
    }
    movie.backdrop945530 = [json objectForKey:kNewBackDrop945530];
    [movie commit];
}

// Init movie from json search
+ (Movie *)initMovieFromJSONSearch:(NSDictionary *)json {
    Movie *newMovie = [Movie new];
    newMovie.movieID = [Utilities nullToObject:json key:kDocMovieId andType:kTypeString];
    newMovie.movieName = [Utilities nullToObject:json key:kDocMovieName andType:kTypeString];
    newMovie.knownAs = [Utilities nullToObject:json key:kDocKnownAs andType:kTypeString];
    newMovie.poster = [Utilities nullToObject:json key:kDocPoster andType:kTypeString];
    newMovie.plotVI = [Utilities nullToObject:json key:kDocMoviePlotVi andType:kTypeString];
    newMovie.sequence = [[json objectForKey:kDocMoreSequene] integerValue];
    newMovie.episode = [[json objectForKey:kDocEpisode] integerValue];
    return newMovie;
}

@end
