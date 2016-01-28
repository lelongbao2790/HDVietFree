//
//  PlayMovieCell.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/27/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Movie;
@interface PlayMovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbCast;
@property (weak, nonatomic) IBOutlet UILabel *lbTagMovie;
@property (weak, nonatomic) IBOutlet UILabel *lbCountry;
@property (weak, nonatomic) IBOutlet UILabel *lbReleaseDate;
@property (weak, nonatomic) IBOutlet UITextView *lbPlot;

- (void)setDetailInformation:(Movie *)movie;

@end
