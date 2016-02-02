//
//  Movie.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "Movie.h"

@implementation Movie
@dynamic movieID, movieName, knownAs, trailer, poster, poster124x184, sequence, currentSeason, episode, runtime, cast, plotVI, country, releaseDate, tagMovie, genreMovie, bannerMovie, backdrop, backdrop945530, relativeMovie, category, pageNumber, totalRecord;

+ (DBIndexDefinition *)indexDefinitionForEntity {
    
    /* if you return an index definition object, then DBAccess will maintain the indexed based on this */
    
    DBIndexDefinition* idx = [DBIndexDefinition new];
    [idx addIndexForProperty:@"movieName" propertyOrder:DBIndexSortOrderAscending];
    return idx;
    
}

// Init movie from json
+ (Movie *)detailRelativeMovieFromJson:(NSDictionary *)json {
    Movie *newMovie = [Movie new];
    newMovie.movieID = [json objectForKey:kMovieId];
    newMovie.movieName = [json objectForKey:kMovieRelativeName];
    newMovie.knownAs = [json objectForKey:kKnownAs];
    newMovie.poster124x184 = [json objectForKey:kPoster124184];
    newMovie.poster = [json objectForKey:kPosterLink];
    newMovie.sequence = [[json objectForKey:kSequence] integerValue];
    newMovie.episode = [[json objectForKey:kEpisode] integerValue];
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
    newMovie.bannerMovie = [json objectForKey:kBannerFilm];
    newMovie.backdrop = [json objectForKey:kBackDrop];
    newMovie.tagMovie = tagMovie;
    newMovie.genreMovie = genreMovie;
    return newMovie;
}

// Update information movie
+ (void)updateInformationMovieFromJSON:(NSDictionary *)json andMovie:(Movie *)movie {
    
    // Information
    movie.movieID = movie.movieID;
    movie.movieName = [json objectForKey:kMovieName];
    movie.knownAs = [json objectForKey:kKnownAs];
    movie.trailer = [json objectForKey:kTrailer];
    movie.sequence = [[json objectForKey:kSequence] integerValue];
    movie.currentSeason = [[json objectForKey:kCurrentSeason] integerValue];
    movie.episode = [[json objectForKey:kEpisode] integerValue];
    movie.cast = [json objectForKey:kCast];
    movie.plotVI = [json objectForKey:kPlotVI];
    movie.country = [json objectForKey:kCountry];
    movie.releaseDate = [json objectForKey:kReleaseDate];
    movie.genreMovie = [MovieSearch share].tagMovie;
    
    // Update category
    NSArray *listCategory = [json objectForKey:kCategoryFilm];
    movie.category = kEmptyString;
    for (NSDictionary *category in listCategory) {
        if ([movie.category isEqualToString:kEmptyString]) {
            movie.category = [NSString stringWithFormat:@"%@",[category objectForKey:kCategoryName]];
        } else {
            movie.category = [NSString stringWithFormat:@"%@, %@", movie.category, [category objectForKey:kCategoryName]];
        }
        
    }
    
    NSArray *listRelativeFromJson = [json objectForKey:kRelative];
    
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
    newMovie.movieID = [json objectForKey:kDocMovieId];
    newMovie.movieName = [json objectForKey:kDocMovieName];
    newMovie.knownAs = [json objectForKey:kDocKnownAs];
    newMovie.poster = [json objectForKey:kDocPoster];
    newMovie.plotVI = [json objectForKey:kDocMoviePlotVi];
    return newMovie;
}

@end
