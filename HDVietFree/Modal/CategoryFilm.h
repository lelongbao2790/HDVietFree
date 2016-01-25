//
//  CategoryFilm.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryFilm : NSObject

// Property
@property (strong, nonatomic) NSString *categoryID;
@property (strong, nonatomic) NSString *categoryName;

// Init movie from json
+ (CategoryFilm *)categoryFromJSON:(NSDictionary *)json;

@end
