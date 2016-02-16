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
@"Phim bộ", [NSNumber numberWithInteger:2], \
@"Cập nhập dữ liệu", [NSNumber numberWithInteger:3], \
@"Trang chủ", [NSNumber numberWithInteger:4], \
@"Đăng xuất", [NSNumber numberWithInteger:5], nil]

#define kDicLeftMenuImage [[NSDictionary alloc] initWithObjectsAndKeys: \
[NSArray arrayWithObjects: @"phimle_icon.png", @"phimle_select_icon.png",nil], [NSNumber numberWithInteger:1], \
[NSArray arrayWithObjects: @"phimbo_icon.png", @"phimbo_select_icon.png",nil], [NSNumber numberWithInteger:2], \
[NSArray arrayWithObjects: @"update_icon.png", @"update_select_icon.png",nil], [NSNumber numberWithInteger:3], \
[NSArray arrayWithObjects: @"home_icon.png", @"home__select_icon.png",nil], [NSNumber numberWithInteger:4], \
[NSArray arrayWithObjects: @"logout_icon.png", @"logout_select_icon.png",nil], [NSNumber numberWithInteger:5], nil]

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
@"Âu mỹ", @"au-my", \
@"Gia đình", @"gia-dinh", \
@"Châu á", @"chau-a", \
@"Hồng kông", @"hong-kong", \
@"Hàn quốc", @"han-quoc", \
@"Lịch sử", @"lich-su", \
@"Tài liệu", @"tai-lieu", \
@"Phim chiếu rạp", @"chieu-rap", \
@"Sắp chiếu", @"sap-chieu", \
@"Thần thoại", @"than-thoai", nil]

// Dict for main menu
#define kDicMainMenuPhimBo [[NSDictionary alloc] initWithObjectsAndKeys: \
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
@"Âu mỹ", @"au-my", \
@"Gia đình", @"gia-dinh", \
@"Châu á", @"chau-a", \
@"Hồng kông", @"hong-kong", \
@"Hàn quốc", @"han-quoc", \
@"Lịch sử", @"lich-su", \
@"Tài liệu", @"tai-lieu", \
@"Thần thoại", @"than-thoai", nil]

// Fixed auto layout for multiple device
#define kFixAutoLayoutForIp4 @"fixAutolayoutFor35"
#define kFixAutoLayoutForIp5 @"fixAutolayoutFor40"
#define kFixAutoLayoutForIp6 @"fixAutolayoutFor47"
#define kFixAutoLayoutForIp6Plus @"fixAutolayoutFor55"
#define kFixAutoLayoutForIpad @"fixAutolayoutForIpad"

#define kResolution320480 @"320_480"
#define kResolution3201024 @"320_1024"
#define kResolution320568 @"320_568"
#define kResolution6401136 @"640_1136"
#define kResolution7681024 @"768_1024"
#define kResolution7501334 @"750_1334"
#define kResolution375667 @"375_667"
#define kResolution12422208 @"1242_2208"
#define kResolution15362048 @"1536_2048"
#define kResolution17921008 @"1792_1008"
#define kSecretKey @"anDroidhdv1et20130924"
#define kMessageErrorAboutMovie @"Hiện chưa có thông tin film này."
#define kErrorDict @"Có lỗi xảy ra"

@end
