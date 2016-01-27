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

#endif /* UIDelegate_h */
