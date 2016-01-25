//
//  Enumeration.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#ifndef Enumeration_h
#define Enumeration_h

typedef NS_ENUM(NSInteger, SearchMovie) {
    kGenrePhimHot = 0,
    kGenrePhimLe = 1,
    kGenrePhimBo = 2,
    kPageDefault = 1,
};

typedef NS_ENUM(NSInteger, TagMainController) {
    kTagCollectionTopMenu = 101,
    kTagCollectionDetailMovie = 100,
};

typedef NS_ENUM(NSInteger, ServerResponseKey) {
    kRequestSuccess = 0,
    kRequestFail = 111,
};

#endif /* Enumeration_h */
