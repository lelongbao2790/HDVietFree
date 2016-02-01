//
//  SearchCell.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/1/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgPoster;
@property (weak, nonatomic) IBOutlet UILabel *lbNameMovie;
@property (weak, nonatomic) IBOutlet UILabel *lbPlot;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoading;

- (void)loadInformationWithMovie:(Movie *)movie;

@end
