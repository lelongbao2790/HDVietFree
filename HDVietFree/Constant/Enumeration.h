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
    kTagMPMoviePlayerController = 1004,
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
    kPositionYTextField = 5,
    kCornerRadius = 15,
};

typedef NS_ENUM(NSInteger, ControllerTag) {
    kTagMainController = 1,
    kTagPlayController = 2,
    kTimeOutIntervalSession = 30,
    kTopConstantTableView = 386,
    kTopConstantTableViewIp6Plus = 186,
    kTopConstantTableViewIp6 = 170,
    kConstantInformationViewIp4 = 310,
    kConstantInformationViewIp5 = 350,
    kConstantInformationViewIp6 = 500,
    kConstantInformationViewIp6Plus = 500,
    kConstantInformationViewIpad = 700,
    k400BadRequest = 400,
};

typedef NS_ENUM(NSInteger, PlayConstant) {
    kWidthConstantIp5 = 138,
};

typedef NS_ENUM(NSInteger, LoginConstant) {
    kTopConstantIp5 = 30,
    kTopConstantIp6 = 40,
    kTopConstantIp6Plus = 50,
    kTopConstantIpad = 150,
    kLeadingConstantLogin = 30,
    kBottomConstantIpad = 120,
    kHeighSpaceImageLeftConstantIpad = 90,
    kLeadingTableViewMainIphone = -16,
    kTralingTableViewMainIphone = -16,
    kLeadingTableViewMainIphone55 = -20,
    kTralingTableViewMainIphone55 = -20,
    kLeadingTableViewMainIpad = -20,
    kTralingTableViewMainIpad = -20,
    kSpaceBottomListMenu = 500,
    kLeadingEpisodeIp5 = 50,
    kLeadingEpisodeIp6 = 60,
    kLeadingEpisodeIp6Plus = 65,
    kTagLabelEpisode = 202,
    kTagCollectionViewEpisode = 201,
    
};

typedef NS_ENUM(NSInteger, ScrollConstant) {
    kHeightContentViewScrollViewIpad = 7000,
    kHeightContentViewScrollViewIp4 = 7360,
    kHeightContentViewScrollViewIp5 = 7300,
    kHeightContentViewScrollViewIp6 = 7240,
    kHeightContentViewScrollViewIp6Plus = 7220,
};


typedef NS_ENUM(NSInteger, InformationConstant) {
    kWidthConstantPlot = 20,
    kWidthConstantCollectionView = 2,
    kLeadingTrailerConstant = 10,
    
};

typedef NS_ENUM(NSInteger, PositionArray) {
    kListDataPosition = 0,
    kTotalRecordPosition = 1,
    kPageResponsePosition = 2,
    kGenreNumberPosition = 3,
    kTagMoviePosition = 4,
};

typedef NS_ENUM(NSInteger, Type) {
    kTypeString = 0,
    kTypeInteger = 1,
    kTypeArray = 2,
    kTypeFilm = 3,
    kTypeMain = 4,
    kTagFilmController = 101,
    kTagInformation = 102,
};
#endif /* Enumeration_h */
