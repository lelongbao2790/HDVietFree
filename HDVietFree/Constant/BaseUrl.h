//
//  BaseUrl.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#ifndef BaseUrl_h
#define BaseUrl_h

// Base Url
#define kBaseUrlSSL @"https://api-v2.hdviet.com/"
#define kBaseUrlHDO @"http://api.hdonline.vn/v2/"
#define kBaseUrl @"http://rest.hdviet.com/"
#define kUrlHdViet @"http://movies.hdviet.com/"
#define kUrlImagePosterHdViet @"http://t.hdviet.com/thumbs/origins/%@"
#define kUrlImageBannerHdViet @"http://t.hdviet.com/backdrops/origins/%@"
#define kUrlHttpTHdViet @"t.hdviet.com"
#define kUrlTvChannelHTVOnline @"http://api.htvonline.com.vn/tv_channels"

// List api
#define kUrlAllSeason @"movie/getallseason?movieid=%@"
#define kUrlLogin @"user/login?email=%@&password=%@"
#define kUrlCategory @"category/menu?mini=1&sequence=%d"
#define kUrlDetailMovie @"movie?movieid=%@"
#define kUrlListMovieByGenre @"api/v3/movie/filter?genre=%d&tag=%@&page=%d&limit=0"
#define kUrlPlayMovie @"movie/play?movieid=%@&accesstokenkey=%@&ep=%d"
#define kUrlSearchMovieWithKeyword @"api/v3/search?keyword=%@&page=1&limit=100"
#define kUrlGetAllCategory @"category"

//List api HDO
#define kUrlLoginHDO @"user/login?token=%@&username=%@&password=%@"
#define kUrlGetTokenHDO @"index/gettoken?client=tablet&clientsecret=eba71161466442ff1733fd0c022ac957&device=tablet&platform=ios&version=1.0"
#define kUrlHDODeCu @"film/list/type/votehome?limit=%d&offset=%d&token=%@"
#define kUrlPhimLeHDO @"film/list/type/single?limit=%d&offset=%d&token=%@"
#define kUrlPhimboHDO @"film/list/type/drama?limit=%d&offset=%d&token=%@"
#define kUrlGetListGenreHDO @"episode?film=%d&token=%d"
#define kUrlPlayMovieHDO @"episode/play?id=%d&token=%@"

// Google spread sheet for report bug
#define kUrlGoogleReportBug @"https://docs.google.com/forms/d/1n9xqo59r-cyzvq5NudccyHbDS5m9QhpdongRz-buFsk/formResponse"
#define kRegisterUrl @"https://id.hdviet.com/dang-ki-moi?token=dXJsPWh0dHA6Ly9tb3ZpZXMuaGR2aWV0LmNvbSYmdXJsX3JlZGlyZWN0PWh0dHA6Ly9tb3ZpZXMuaGR2aWV0LmNvbQ=="

#endif /* BaseUrl_h */
