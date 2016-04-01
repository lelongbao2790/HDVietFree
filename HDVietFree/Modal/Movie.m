//
//  Movie.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "Movie.h"

//*****************************************************************************
#pragma mark -
#pragma mark - ** Movie **

@implementation Movie
@dynamic movieID, movieName, trailer, episode, runtime, cast, plotVI, releaseDate, tagMovie, genreMovie, bannerMovie, backdrop, pageNumber, totalRecord, urlLinkPlayMovie, urlLinkSubtitleMovie, imdbRating, seasonId, timePlay, epiNumber, category, sequence, poster;

+ (DBIndexDefinition *)indexDefinitionForEntity {
    
    /* if you return an index definition object, then DBAccess will maintain the indexed based on this */
    
    DBIndexDefinition* idx = [DBIndexDefinition new];
    [idx addIndexForProperty:@"movieName" propertyOrder:DBIndexSortOrderAscending];
    return idx;
    
}


@end

//*****************************************************************************
#pragma mark -
#pragma mark - ** Movie HDV **
@implementation MovieHDV
@dynamic knownAs, poster124x184, currentSeason, country, relativeMovie, backdrop945530;
@dynamic movieID, movieName, trailer, episode, runtime, cast, plotVI, releaseDate, tagMovie, genreMovie, bannerMovie, backdrop, pageNumber, totalRecord, urlLinkPlayMovie, urlLinkSubtitleMovie, imdbRating, seasonId, timePlay, epiNumber, category, sequence, poster;

// Init movie from json
+ (MovieHDV *)detailRelativeMovieFromJson:(NSDictionary *)json {
    MovieHDV *newMovie = [MovieHDV new];
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
+ (MovieHDV *)detailListMovieFromJSON:(NSDictionary *)json withTag:(NSString *)tagMovie andGenre:(NSString *)genreMovie {
    
    MovieHDV *newMovie = [MovieHDV new];
    newMovie.movieID = [json objectForKey:kMovieId];
    newMovie.movieName = [Utilities nullToObject:json key:kMovieName andType:kTypeString];
    newMovie.knownAs = [Utilities nullToObject:json key:kKnownAs andType:kTypeString];
    newMovie.trailer = [Utilities nullToObject:json key:kTrailer andType:kTypeString];
    newMovie.poster = [Utilities nullToObject:json key:kNewPoster andType:kTypeString];
    newMovie.sequence = [[json objectForKey:kSequence] integerValue];
    newMovie.currentSeason = [[json objectForKey:kCurrentSeason] integerValue];
    newMovie.episode = [[json objectForKey:kEpisode] integerValue];
    newMovie.cast = [Utilities nullToObject:json key:kCast andType:kTypeString];
    newMovie.plotVI = [[Utilities nullToObject:json key:kPlotVI andType:kTypeString] stringByStrippingHTML];
    newMovie.country = [Utilities nullToObject:json key:kCountry andType:kTypeString];
    newMovie.bannerMovie = [Utilities nullToObject:json key:kBannerFilm andType:kTypeString];
    newMovie.backdrop = [Utilities nullToObject:json key:kBackDrop andType:kTypeString];
    newMovie.imdbRating = [NSString stringWithFormat:@"%.02f",[[json objectForKey:kImdbRating] floatValue]];
    newMovie.tagMovie = tagMovie;
    newMovie.genreMovie = genreMovie;
    return newMovie;
}

// Update information movie
+ (void)updateInformationMovieFromJSON:(NSDictionary *)json andMovie:(MovieHDV *)movie {
    // Information
    movie.movieID = movie.movieID;
    movie.movieName = [Utilities nullToObject:json key:kMovieName andType:kTypeString];
    movie.knownAs = [Utilities nullToObject:json key:kKnownAs andType:kTypeString];
    movie.trailer = [Utilities nullToObject:json key:kTrailer andType:kTypeString];
    movie.sequence = [[json objectForKey:kSequence] integerValue];
    movie.currentSeason = [[json objectForKey:kCurrentSeason] integerValue];
    movie.episode = [[json objectForKey:kEpisode] integerValue];
    movie.cast = [Utilities nullToObject:json key:kCast andType:kTypeString];
    movie.plotVI = [[Utilities nullToObject:json key:kPlotVI andType:kTypeString] stringByStrippingHTML];
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
        MovieHDV *movieFromLocal = (MovieHDV *)[[DataAccess share] getMovieFromId:[dictMovie objectForKey:kMovieId]];
        if (movieFromLocal == nil) {
            // Movie not exist in local
            MovieHDV *aMovie = (MovieHDV *)[MovieHDV detailRelativeMovieFromJson:dictMovie];
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
+ (MovieHDV *)initMovieFromJSONSearch:(NSDictionary *)json {
    MovieHDV *newMovie = [MovieHDV new];
    newMovie.movieID = [Utilities nullToObject:json key:kDocMovieId andType:kTypeString];
    newMovie.movieName = [Utilities nullToObject:json key:kDocMovieName andType:kTypeString];
    newMovie.knownAs = [Utilities nullToObject:json key:kDocKnownAs andType:kTypeString];
    newMovie.poster = [Utilities nullToObject:json key:kDocPoster andType:kTypeString];
    newMovie.plotVI = [[Utilities nullToObject:json key:kDocMoviePlotVi andType:kTypeString] stringByStrippingHTML];
    newMovie.sequence = [[json objectForKey:kDocMoreSequene] integerValue];
    newMovie.episode = [[json objectForKey:kDocEpisode] integerValue];
    return newMovie;
}

// Init season movie
+ (void)initSeasonMovieFromJSONSearch:(NSDictionary *)json andMovie:(Movie *)oldMovie {
    MovieHDV *newMovie = nil;
    MovieHDV *movieFromLocal = (MovieHDV *)[[DataAccess share] getMovieFromId:[json objectForKey:kMovieId]];
    
    if (movieFromLocal == nil) {
        newMovie = [MovieHDV new];
        newMovie.movieID = [Utilities nullToObject:json key:kMovieId andType:kTypeString];
    }
    else {
        newMovie = movieFromLocal;
    }
    newMovie.movieName = [Utilities nullToObject:json key:kMovieName andType:kTypeString];
    newMovie.sequence = [[json objectForKey:kSequence] integerValue];
    newMovie.episode = [[json objectForKey:kEpisode] integerValue];
    newMovie.poster = [Utilities nullToObject:json key:kPosterLink andType:kTypeString];
    newMovie.backdrop = [Utilities nullToObject:json key:kBackDrop andType:kTypeString];
    newMovie.seasonId = oldMovie.movieID;
    [newMovie commit];
}

@end
//*****************************************************************************
#pragma mark -
#pragma mark - ** Movie HDO **
@implementation MovieHDO
@dynamic slug, keyMovie, updateEpisode;
@dynamic movieID, movieName, trailer, episode, runtime, cast, plotVI, releaseDate, tagMovie, genreMovie, bannerMovie, backdrop, pageNumber, totalRecord, urlLinkPlayMovie, urlLinkSubtitleMovie, imdbRating, seasonId, timePlay, epiNumber, category, sequence, poster;

+ (MovieHDO *)initMovieFromJSON:(NSDictionary *)json withKey:(NSString *)key {
    MovieHDO *newMovie = [MovieHDO new];
    newMovie.movieID = [Utilities nullToObject:json key:kDocMovieId andType:kTypeString];
    newMovie.movieName = [Utilities nullToObject:json key:kNameMovieVN andType:kTypeString];
    newMovie.plotVI = [[Utilities nullToObject:json key:kInfo andType:kTypeString] stringByStrippingHTML];
    newMovie.imdbRating = [Utilities nullToObject:json key:kImdb andType:kTypeString];
    newMovie.releaseDate = [Utilities nullToObject:json key:kYear andType:kTypeString];
    newMovie.trailer = [Utilities nullToObject:json key:kTrailer.lowercaseString andType:kTypeString];
    newMovie.sequence = [[json objectForKey:kSequence.lowercaseString] integerValue];
    newMovie.category = [Utilities nullToObject:json key:kCategoryFilm.lowercaseString andType:kTypeString];
    newMovie.slug = [Utilities nullToObject:json key:kSlug andType:kTypeString];
    newMovie.updateEpisode = [Utilities nullToObject:json key:kUpdateEpisode andType:kTypeString];
    
    NSDictionary *listImage = [json objectForKey:kImageList];
    newMovie.poster = [Utilities nullToObject:listImage key:k215311 andType:kTypeString];
    newMovie.bannerMovie = [Utilities nullToObject:listImage key:k900500 andType:kTypeString];
    newMovie.backdrop = [Utilities nullToObject:listImage key:k900500 andType:kTypeString];
    newMovie.keyMovie = key;
    
    return newMovie;
}

+ (MovieHDO *)updateMovieFromJSON:(NSDictionary *)json {
    
    NSDictionary *dictFilm = [json objectForKey:kFilm];
    MovieHDO *movie = (MovieHDO *)[[DataAccess share] getMovieFromId:[dictFilm objectForKey:kDocMovieId]];
    if (movie) {
        movie.movieID = [Utilities nullToObject:json key:kDocMovieId andType:kTypeString];
    }
    return movie;
}

@end