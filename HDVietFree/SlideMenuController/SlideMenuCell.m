//
//  SlideMenuCell.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/27/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "SlideMenuCell.h"

@implementation SlideMenuCell
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        
        self.nameItem.textColor = [UIColor blackColor];
        self.imageItem.image = [UIImage imageNamed:kDicLeftMenuImage.allValues[self.row][1]];
    } else {
        self.nameItem.textColor = [UIColor whiteColor];
        self.imageItem.image = [UIImage imageNamed:kDicLeftMenuImage.allValues[self.row][0]];
    }
    
}

- (void)setInformationCell:(NSString *)name {
    self.nameItem.text = name;
    self.imageItem.image = [UIImage imageNamed:kDicLeftMenuImage.allValues[self.row][0]];
    
}

@end
