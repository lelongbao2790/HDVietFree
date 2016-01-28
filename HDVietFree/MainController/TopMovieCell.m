//
//  TopMovieCell.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/28/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "TopMovieCell.h"

@implementation TopMovieCell

/*
 * Load image on cell
 */
- (void)loadInformationOnTop:(Movie *)aMovie {
    
    if ([Utilities isExistImage:aMovie.backdrop]) {
        // Exist image
        [self.activityLoading stopAnimating];
        self.backdropImage.image = [Utilities loadImageFromName:aMovie.backdrop];
        
    } else {
        self.backdropImage.image = nil;
        [self.activityLoading startAnimating];
        // Not exist
        __block NSData *data = nil;
        NSString *strImageUrl = [NSString stringWithFormat:kUrlImageBannerHdViet, aMovie.backdrop];
        NSURL *urlImage = [NSURL URLWithString:strImageUrl];
        
        dispatch_queue_t backgroundQueue = dispatch_queue_create(kLoadImageInBackground, 0);
        dispatch_async(backgroundQueue, ^{
            
            // Download
            data = [NSData dataWithContentsOfURL:urlImage];
            UIImage *image = [UIImage imageWithData:data];
            [Utilities saveImage:image withName:aMovie.backdrop];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // Load image on UI
                [self.activityLoading stopAnimating];
                self.backdropImage.image = [Utilities loadImageFromName:aMovie.backdrop];
            });
        });
    }
}

@end
