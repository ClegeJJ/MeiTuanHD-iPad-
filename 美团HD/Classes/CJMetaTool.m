//
//  CJMetaTool.m
//  美团HD
//
//  Created by mac527 on 15/10/29.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJMetaTool.h"
#import "CJCity.h"
#import "MJExtension.h"
@implementation CJMetaTool

static NSArray *_cities;
+ (NSArray *)cities
{
    if (!_cities) {
        _cities = [CJCity objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}
@end
