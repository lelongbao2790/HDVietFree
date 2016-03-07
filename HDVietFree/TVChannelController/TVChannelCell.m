//
//  TVChannelCell.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 3/7/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "TVChannelCell.h"

@implementation TVChannelCell

- (void)loadInformation {
    
    // Config sub view
    self.subviewCell.layer.cornerRadius = 5.0;
    self.subviewCell.layer.masksToBounds = YES;
    self.subviewCell.layer.borderColor = [UIColor whiteColor].CGColor;
    self.subviewCell.layer.borderWidth = 1.0f;
    
    // request image
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.tvChannel.imageChannel]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    
    [self.imageChannel setImageWithURLRequest:imageRequest
                           placeholderImage:[UIImage imageNamed:kNoBannerImage]
                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                        self.imageChannel.image = image;
                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                        self.imageChannel.image = [UIImage imageNamed:kNoBannerImage];
                                    }];
}

@end
