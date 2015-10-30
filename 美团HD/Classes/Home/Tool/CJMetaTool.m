//
//  CJMetaTool.m
//  美团HD
//
//  Created by mac527 on 15/10/29.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJMetaTool.h"
#import "CJCity.h"
#import "CJSort.h"
#import "CJCategory.h"
#import "MJExtension.h"
@implementation CJMetaTool

static NSArray *_cities,*_categories,*_sort;
+ (NSArray *)cities
{
    if (!_cities) {
        _cities = [CJCity objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}

+ (NSArray *)categories
{
    if (!_categories) {
        _categories = [CJCategory objectArrayWithFilename:@"categories.plist"];
    }
    return _categories;

}

+ (NSArray *)sorts
{
    if (!_sort) {
        _sort = [CJSort objectArrayWithFilename:@"sorts.plist"];
    }
    return _sort;
}

@end
