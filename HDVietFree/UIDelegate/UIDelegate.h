//
//  UIDelegate.h
//  ProtoEditor
//
//  Created by Bao (Brian) L. LE on 1/5/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#ifndef UIDelegate_h
#define UIDelegate_h
#import <Foundation/Foundation.h>
#import "Movie.h"
/*
 * Login Delegate
 */
@protocol LoginDelegate
@optional
-(void) loginAPISuccess:(NSDictionary *)response;
-(void) loginAPIFail:(NSString *)resultMessage;
@end

/*
 * Load movie
 */
@protocol ListMovieByGenreDelegate
@optional
-(void) loadListMovieAPISuccess:(NSDictionary *)response atTag:(NSString *)tagMovie andGenre:(NSString *)genre;
-(void) loadListMovieAPIFail:(NSString *)resultMessage;
@end

/*
 * Load detail information movie
 */
@protocol DetailInformationMovieDelegate
@optional
-(void) loadDetailInformationMovieAPISuccess:(NSDictionary *)response;
-(void) loadDetailInformationMovieAPIFail:(NSString *)resultMessage;
@end

/*
 * Load link play movie
 */
@protocol LoadLinkPlayMovieDelegate
@optional
-(void) loadLinkPlayMovieAPISuccess:(NSDictionary *)response;
-(void) loadLinkPlayMovieAPIFail:(NSString *)resultMessage;
@end

/*
 * Search movie delegate
 */
@protocol SearchMovieDelegate
@optional
-(void) searchMovieAPISuccess:(NSDictionary *)response;
-(void) searchMovieAPIFail:(NSString *)resultMessage;
@end

/*
 * Report bug delegate
 */
@protocol ReportBugDelegate
@optional
-(void) reportBugAPISuccess:(NSDictionary *)response;
-(void) reportBugAPIFail:(NSString *)resultMessage;
@end

/*
 * Load detail information movie
 */
@protocol AllSeasonDelegate
@optional
-(void) getAllSeasonAPISuccess:(NSDictionary *)response;
-(void) getAllSeasonAPIFail:(NSString *)resultMessage;
@end

/*
 * Load detail information movie
 */
@protocol TVChannelDelegate
@optional
-(void) getAllTVChannelAPISuccess:(NSDictionary *)response;
-(void) getAllTVChannelAPIFail:(NSString *)resultMessage;
@end

#endif /* UIDelegate_h */
