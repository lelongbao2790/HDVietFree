
//
//  DetailMovieCell.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "DetailMovieCell.h"

@implementation DetailMovieCell

- (void)loadInformationWithMovie:(Movie *)movie {
    self.lbNameMovie.text = movie.movieName;
    [self setImagePoster:movie];
    DLOG(@"Movie name: %@", movie.movieName);
}

/*
 * Set avatar image
 */
- (void)setImagePoster:(Movie *)movie {
    // Using GCD to download image
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        // Download
        UIImage *imageFromCache = [[Utilities share]getCachedImageForKey:movie.poster];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (imageFromCache) {
                [self updateUIImageAvatar:imageFromCache withMovie:movie];
            } else {
                if ([Utilities isExistImage:movie.poster]) {
                    // Exist image
                    [self updateUIImageAvatar:[Utilities loadImageFromName:movie.poster] withMovie:movie];
                } else {
                    [self downloadImageWithLibrary:movie];
                    
                }
            }
        });
    });
}

- (void)downloadImageWithLibrary:(Movie *)movie {
    if (movie.poster) {
        NSString *strImageUrl = [Utilities getStringUrlPoster:movie];
        [[DataManager shared] downloadImageWithUrl:strImageUrl completionBlock:^(BOOL success, UIImageLoaderImage *image) {
            if (success) {
                [self updateUIImageAvatar:image withMovie:movie];
            } else {
                //there was not a cached image available, set a placeholder or do nothing.
                self.imageMovie.image = nil;
                [self.activityLoading startAnimating];
            }
        }];
    } else {
        [self updateUIImageAvatar:nil withMovie:movie];
    }
}


// This method will update image avatar
- (void)updateUIImageAvatar:(UIImage*)images withMovie:(Movie *)movie {
    [self.activityLoading stopAnimating];
    self.lbNameMovie.text = movie.movieName;
    if (images) {
        self.imageMovie.image = images;
    } else {
        self.imageMovie.image = [UIImage imageNamed:kNoImage];
    }
}

@end
