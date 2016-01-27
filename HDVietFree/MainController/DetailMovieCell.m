//
//  DetailMovieCell.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "DetailMovieCell.h"
#define kLoadImageInBackground "backgroundDownloadImage"

@implementation DetailMovieCell

- (void)loadInformationWithMovie:(Movie *)movie {
    [self.activityLoading startAnimating];
    [self setImagePoster:movie];
}

/*
 * Set avatar image
 */
- (void)setImagePoster:(Movie *)movie {
    // Init data image
    __block NSData *dataPosterMovie;
    
    // Load image from url poster
    if (movie.poster !=nil) {
        NSString *strImageUrl = [NSString stringWithFormat:kUrlImagePosterHdViet, movie.poster];
        NSURL *urlImage = [NSURL URLWithString:strImageUrl];
        NSUserDefaults *imagePoster = [NSUserDefaults standardUserDefaults];
        
        // Download image avatar if image is not save on local phone
        if ([imagePoster objectForKey:movie.poster] ==nil) {
            dispatch_queue_t backgroundQueue = dispatch_queue_create(kLoadImageInBackground, 0);
            dispatch_async(backgroundQueue, ^{
                
                // Download
                dataPosterMovie = [NSData dataWithContentsOfURL:urlImage];
                [imagePoster setObject:dataPosterMovie  forKey:movie.poster];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // Load image on UI
                    [self updateUIImageAvatar:[UIImage imageWithData:dataPosterMovie] withMovie:movie];
                });
            });
        }
        
        // Load image avatar on local phone if it is exist
        else {
            dataPosterMovie = [imagePoster objectForKey:movie.poster];
            [self updateUIImageAvatar:[UIImage imageWithData:dataPosterMovie] withMovie:movie];
        }
    }
    
    // Load default avatar image if url image is nil
    else {
        
    }
}

// This method will update image avatar
- (void)updateUIImageAvatar:(UIImage*)images withMovie:(Movie *)movie {
    [self.activityLoading stopAnimating];
    self.imageMovie.image = images;
    self.lbNameMovie.text = movie.movieName;
    
}

@end
