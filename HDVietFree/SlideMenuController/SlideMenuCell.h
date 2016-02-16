//
//  SlideMenuCell.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/27/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideMenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageItem;
@property (weak, nonatomic) IBOutlet UILabel *nameItem;
@property (assign, nonatomic) NSInteger row;
- (void)setInformationCell:(NSString *)name;

@end
