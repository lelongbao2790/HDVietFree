//
//  TVChannel.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 3/7/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <DBAccess/DBAccess.h>

@interface TVChannel : DBObject

@property (strong, nonatomic) NSString *idChannel;
@property (strong, nonatomic) NSString *nameChannel;
@property (strong, nonatomic) NSString *imageChannel;
@property (strong, nonatomic) NSString *linkPlayChannel;
@property (strong, nonatomic) NSString *intro;

// Init channel from json
+ (void)initChannelFromJSON:(NSDictionary *)json;

@end
