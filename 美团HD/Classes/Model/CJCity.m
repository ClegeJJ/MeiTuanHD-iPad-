//
//  CJCity.m
//  美团HD
//
//  Created by mac527 on 15/10/29.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJCity.h"
#import "MJExtension.h"
#import "CJRegion.h"
@implementation CJCity
+ (NSDictionary *)objectClassInArray
{
    return @{ @"regions" : [CJRegion class]};
}
@end
