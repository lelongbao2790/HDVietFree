//
//  DataManager.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface DataManager : AFHTTPSessionManager {
     NSObject<LoginDelegate> *loginDelegate;
}

@property (strong, nonatomic) NSObject *loginDelegate;

//*****************************************************************************
#pragma mark -
#pragma mark ** Singleton object **
+ (DataManager *)shared;

//*****************************************************************************
#pragma mark -
#pragma mark ** Helper Method **
/*
 * POST LOGIN
 *
 * @param strUrl url string request
 */
- (void)postLoginWithUrl:(NSString *)strUrl;

@end
