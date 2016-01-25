//
//  CategoryFilm.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "CategoryFilm.h"

@implementation CategoryFilm

// Init movie from json
+ (CategoryFilm *)categoryFromJSON:(NSDictionary *)json {
    CategoryFilm *newCategory = [[CategoryFilm alloc] init];
    newCategory.categoryID = [json objectForKey:kCategoryID];
    newCategory.categoryName = [json objectForKey:kCategoryName];
    return newCategory;
}

@end
