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
    kTagImageCollectionTop = 105,
    kTagActivityLoadingTop = 106,
};

typedef NS_ENUM(NSInteger, ServerResponseKey) {
    kRequestSuccess = 0,
    kRequestFail = 111,
};

typedef NS_ENUM(NSInteger, PlayMovieTagTableView) {
    kSectionInformationMovie = 0,
    kSectionCategoryFilm = 1,
    kNumberOfSectionPlayMovie = 2,
    kSpaceWidthTextField = 70,
    kSpaceTrailingWidthTextField = 8,
    kHeightTextField = 32,
    kHeightOfRightButton = 36,
    kCornerRadius = 5,
};

typedef NS_ENUM(NSInteger, ControllerTag) {
    kTagMainController = 1,
    kTagPlayController = 2,
    kTimeOutIntervalSession = 60,
    kTopConstantTableView = 540,
    k400BadRequest = 400,
};

typedef NS_ENUM(NSInteger, LoginConstant) {
    kTopConstantIp5 = 30,
    kTopConstantIp6 = 40,
    kTopConstantIp6Plus = 50,
    kTopConstantIpad = 60,
    kLeadingTableViewMainIphone = -16,
    kTralingTableViewMainIphone = -16,
    kLeadingTableViewMainIpad = -20,
    kTralingTableViewMainIpad = -20,
    kSpaceBottomListMenu = 500,
};
#endif /* Enumeration_h */
