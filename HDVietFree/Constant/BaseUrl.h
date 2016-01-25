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
#define kBaseUrl @"http://rest.hdviet.com/"

// List api
#define kUrlLogin @"user/login?email=%@&password=%@"
#define kUrlCategory @"category/menu?mini=1&sequence=0"
#define kUrlDetailMovie @"movie?movieid=%@"
#define kUrlSearchMovie @"api/v3/movie/filter?genre=%@&tag=%@&page=%@&limit=0"
#define kUrlPlayMovie @"movie/play?movieid=%@&accesstokenkey=%@&ep=0"

#endif /* BaseUrl_h */
