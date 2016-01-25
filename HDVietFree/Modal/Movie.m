//
//  Movie.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "Movie.h"

@implementation Movie

// Init movie from json
+ (Movie *)movieFromJSON:(NSDictionary *)json {
    Movie *newMovie = [[Movie alloc] init];
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
    return newMovie;
    
}
@end
