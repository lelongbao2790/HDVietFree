//
//  KeyServer.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#ifndef KeyServer_h
#define KeyServer_h

// User
#define kUserId @"UserID"
#define kUserName @"UserName"
#define kEmail @"Email"
#define kDisplayName @"DisplayName"
#define kAccessToken @"AccessTokenKey"

// Movie
#define kMovieId @"MovieID"
#define kMovieName @"MovieName"
#define kKnownAs @"KnownAs"
#define kTrailer @"Trailer"
#define kPosterLink @"Poster"
#define kPoster124184 @"Poster124x184"
#define kSequence @"Sequence"
#define kCurrentSeason @"CurrentSeason"
#define kEpisode @"Episode"
#define kRuntime @"Runtime"
#define kCast @"Cast"
#define kPlotVI @"PlotVI"
#define kCountry @"Country"
#define kReleaseDate @"ReleaseDate"
#define kCategoryFilm @"Category"

// Category
#define kCategoryID @"CategoryID"
#define kCategoryName @"CategoryName"

// Docs movie search
#define kDocMoviePlotVi @"mo_plot_vi"
#define kDocMovieCast @"mo_cast"
#define kDocWrapLink @"mo_wraplink"
#define kDocKnownAs @"mo_known_as"
#define kDocImdb @"mo_imdb_rating"
#define kDocMovieName @"mo_name"
#define kDocPoster @"mo_new_poster"
#define kDocCategory @"category"
#define kDocReleaseDate @"mo_releamo_date"
#define kDocMovieId @"id"

// Response server
#define kE @"e"
#define kR @"r"
#define kCannotConnectToServer @"Cannot connect to server!"

// Request header
#define kHTTPHeaderApplication @"application/json"
#define kHTTPHeaderContentType @"Content-Type"
#define kErrorResponseObjectKey @"HDVietErrorResponseObjectKey"

#endif /* KeyServer_h */
