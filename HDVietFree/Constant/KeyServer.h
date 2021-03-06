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
#define kPassword @"Password"
#define kEmail @"Email"
#define kDisplayName @"DisplayName"
#define kAccessToken @"AccessTokenKey"
#define kAccessTokenHDO @"AccessTokenKeyHDO"
#define kUserNameHDO @"UserNameHDO"
#define kPasswordHDO @"PasswordHDO"

// Movie
#define kMovieId @"MovieID"
#define kMovieName @"MovieName"
#define kMovieRelativeName @"Name"
#define kKnownAs @"KnownAs"
#define kTrailer @"Trailer"
#define kPosterLink @"Poster"
#define kNewPoster @"NewPoster"
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
#define kBannerFilm @"Banner"
#define kBackDrop @"Backdrop"
#define kNewBackDrop @"NewBackdrop"
#define kNewBackDrop945530 @"NewBackdrop945x530"
#define kRelative @"Relative"
#define k2015 @"2015"
#define k2016 @"2016"
#define kLinkPlay @"LinkPlay"
#define kSubtitleExt @"SubtitleExt"
#define kSubtitleVIE @"VIE"
#define kSubtitleSource @"Source"
#define kSuccess @"success"
#define kMsg @"msg"
#define kResult @"result"
#define kToken @"token"
#define kUser @"user"
#define kUserNameHDOString @"username"

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
#define kDocMoreSequene @"mo_sequence"
#define kDocEpisode @"mo_episode"
#define kDocSeason @"mo_season"
#define kDocs @"docs"

#define kNameMovieVN @"name_vn"
#define kImdb @"imdb"
#define kYear @"year"
#define kInfo @"info"
#define kTotalEpisode @"total_episode"
#define kUpdateEpisode @"update_episode"
#define kImageList @"imagelist"
#define kSlug @"slug"
#define kFilm @"film"
#define k900500 @"900_500"
#define k215311 @"215_311"

// Channel
#define kName @"name"
#define kImage @"image"
#define kIntroText @"intro_text"
#define kLinkm3u8 @"mp3u8_link"
#define kLinkPlayChannel @"link_play"

// Response server
#define kE @"e"
#define kR @"r"
#define kError @"error"
#define kData @"data"
#define kMessage @"message"
#define kCannotConnectToServer @"Cannot connect to server!"
#define kMetadata @"metadata"
#define kList @"lists"
#define kTotalRecord @"totalRecord"
#define kResponse @"response"
#define kImdbRating @"ImdbRating"

#define kGenre @"genre"
#define kTag @"tag"
#define kPage @"page"
#define kShowMovieTop @"moi-cap-nhat"
#define kHTV @"HTV"
#define kVT @"VT"
#define kGeneral @"General"

#define kKenhHTV @"Kênh HTV"
#define kKenhVTV @"Kênh VTV, VTC"
#define kKenhTongHop @"Kênh Tổng Hợp"

// Request header
#define kHTTPHeaderApplication @"application/json"
#define kHTTPHeaderAccessToken @"Access-Token"
#define kHTTPHeaderContentType @"Content-Type"
#define kHTTPHeaderContentTypeValue @"application/x-www-form-urlencoded"
#define kHTTPHeaderAuthorization @"Authorization"
#define kHTTPHeaderAuthorizationValue @"Basic YXBpaGF5aGF5dHY6NDUlJDY2N0Bk"
#define kHTTPHeaderUserAgent @"User-Agent"
#define kHTTPHeaderUserAgentValue @"Apache-HttpClient/UNAVAILABLE (java 1.4)"
#define kHTTPHeaderValue @"application/x-www-form-urlencoded; charset=utf-8"
#define kPostMethod @"POST"

// Body request htvonline
#define kRequestChannelHtvOnline @"request={\"pageCount\":200,\"category_id\":\"-1\",\"startIndex\":0}"

#endif /* KeyServer_h */
