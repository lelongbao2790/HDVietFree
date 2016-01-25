//
//  CommonConstant.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonConstant : NSObject

// Dict for left menu
#define kDicLeftMenu [[NSDictionary alloc] initWithObjectsAndKeys: \
@"Phim lẻ", [NSNumber numberWithInteger:1], \
@"Phim bộ", [NSNumber numberWithInteger:2], nil]

// Dict for main menu
#define kDicMainMenu [[NSDictionary alloc] initWithObjectsAndKeys: \
@"Mới cập nhật", @"moi-cap-nhat", \
@"Hot trong tháng", @"hot-trong-thang", \
@"HDViệt đề cử", @"hdviet-de-cu", \
@"Hành động", @"hanh-dong", \
@"Kinh dị", @"kinh-di", \
@"Hài", @"hai", \
@"Chiến tranh", @"chien-tranh", \
@"Khoa học viễn tưởng", @"khoa-hoc-vien-tuong", \
@"Hình sự tội phạm", @"hinh-su-toi-pham", \
@"Võ thuật", @"vo-thuat", \
@"Tình cảm", @"tinh-cam", \
@"Hoạt hình", @"hoat-hinh", \
@"Anime", @"anime", \
@"Hoạt hình", @"hoat-hinh", \
@"Âm nhạc", @"am-nhac", \
@"Thể thao", @"the-thao", \
@"Tâm lý", @"tam-ly", \
@"Thần thoại", @"than-thoai", nil]

@end
