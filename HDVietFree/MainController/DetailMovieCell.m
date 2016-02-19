
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
    self.imageMovie.image = nil;
    [self.activityLoading startAnimating];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        // Download
        
        UIImage *imageFromCache = [[Utilities share]getCachedImageForKey:movie.poster];
        
        if (imageFromCache) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                 [self updateUIImageAvatar:imageFromCache withMovie:movie];
            });
            
        } else {
            
            if ([Utilities isExistImage:movie.poster]) {
                [[Utilities share] cacheImage:[Utilities loadImageFromName:movie.poster] forKey:movie.poster];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    // Exist image
                    [self updateUIImageAvatar:[Utilities loadImageFromName:movie.poster] withMovie:movie];
                });
                
            } else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self downloadImageWithLibrary:movie];
                });
            }
        }
    });
}

- (void)downloadImageWithLibrary:(Movie *)movie {
    if (movie.poster) {
        NSString *strImageUrl = [Utilities getStringUrlPoster:movie];
        [[DataManager shared] downloadImageWithUrl:strImageUrl completionBlock:^(BOOL success, UIImageLoaderImage *image) {
            if (success) {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue, ^{
                    // Download
                    [Utilities saveImage:image withName:movie.poster];
                    [[Utilities share] cacheImage:image forKey:movie.poster];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self updateUIImageAvatar:image withMovie:movie];
                    });
                });
                
                
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

//- (void)downloadImage:(Movie *)movie {
//    // Not exist
//    self.imageMovie.image = nil;
//    [self.activityLoading startAnimating];
//    NSString *strImageUrl = [Utilities getStringUrlPoster:movie];
//    NSURL *urlImage = [NSURL URLWithString:strImageUrl];
//    
//    // Using GCD to download image

//}


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
