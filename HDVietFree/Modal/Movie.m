//
//  Movie.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "Movie.h"

@implementation Movie
@dynamic movieID, movieName, knownAs, trailer, poster, poster124x184, sequence, currentSeason, episode, runtime, cast, plotVI, country, releaseDate, categoryFilm, tagMovie, genreMovie;

+ (DBIndexDefinition *)indexDefinitionForEntity {
    
    /* if you return an index definition object, then DBAccess will maintain the indexed based on this */
    
    DBIndexDefinition* idx = [DBIndexDefinition new];
    [idx addIndexForProperty:@"movieName" propertyOrder:DBIndexSortOrderAscending];
    return idx;
    
}


// Init movie from json
+ (Movie *)detailMovieFromJSON:(NSDictionary *)json {
    Movie *newMovie = [Movie new];
    newMovie.movieID = [json objectForKey:kMovieId];
    newMovie.movieName = [json objectForKey:kMovieName];
    newMovie.knownAs = [json objectForKey:kKnownAs];
    newMovie.trailer = [json objectForKey:kTrailer];
    newMovie.poster124x184 = [json objectForKey:kPoster124184];
    newMovie.poster = [json objectForKey:kPosterLink];
    newMovie.sequence = [[json objectForKey:kSequence] integerValue];
    newMovie.currentSeason = [[json objectForKey:kCurrentSeason] integerValue];
    newMovie.episode = [[json objectForKey:kEpisode] integerValue];
    newMovie.runtime = [[json objectForKey:kRuntime] integerValue];
    newMovie.cast = [json objectForKey:kCast];
    newMovie.plotVI = [json objectForKey:kPlotVI];
    newMovie.country = [json objectForKey:kCountry];
    newMovie.releaseDate = [json objectForKey:kReleaseDate];
    newMovie.categoryFilm = [CategoryFilm categoryFromJSON:[json objectForKey:kCategoryFilm]];
    [newMovie commit];
    return newMovie;
}

// Init movie from json
+ (Movie *)detailListMovieFromJSON:(NSDictionary *)json withTag:(NSString *)tagMovie andGenre:(NSString *)genreMovie {
    Movie *newMovie = [Movie new];
    newMovie.movieID = [json objectForKey:kMovieId];
    newMovie.movieName = [json objectForKey:kMovieName];
    newMovie.knownAs = [json objectForKey:kKnownAs];
    newMovie.trailer = [json objectForKey:kTrailer];
    newMovie.poster = [json objectForKey:kNewPoster];
    newMovie.sequence = [[json objectForKey:kSequence] integerValue];
    newMovie.currentSeason = [[json objectForKey:kCurrentSeason] integerValue];
    newMovie.episode = [[json objectForKey:kEpisode] integerValue];
    newMovie.cast = [json objectForKey:kCast];
    newMovie.plotVI = [json objectForKey:kPlotVI];
    newMovie.country = [json objectForKey:kCountry];
    newMovie.releaseDate = [json objectForKey:kReleaseDate];
    newMovie.tagMovie = tagMovie;
    newMovie.genreMovie = genreMovie;
    [newMovie commit];
    return newMovie;
}

@end
