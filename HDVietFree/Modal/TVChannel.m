//
//  TVChannel.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 3/7/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "TVChannel.h"

@implementation TVChannel
@dynamic idChannel, nameChannel, linkPlayChannel, imageChannel, intro;

// Init channel from json
+ (void)initChannelFromJSON:(NSDictionary *)json {
    TVChannel *newChannel = [TVChannel new];
    newChannel.idChannel = [Utilities nullToObject:json key:kDocMovieId andType:kTypeString];
    newChannel.nameChannel = [Utilities nullToObject:json key:kName andType:kTypeString];
    NSArray *linkPlay = [Utilities nullToObject:json key:kLinkPlayChannel andType:kTypeString];
    for (NSDictionary *dictPlay in linkPlay) {
        newChannel.linkPlayChannel = [Utilities nullToObject:dictPlay key:kLinkm3u8 andType:kTypeString];
    }
    newChannel.imageChannel = [Utilities nullToObject:json key:kImage andType:kTypeString];
    newChannel.intro = [Utilities nullToObject:json key:kIntroText andType:kTypeString];
    [newChannel commit];
}

@end
