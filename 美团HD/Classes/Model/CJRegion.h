//
//  CJRegion.h
//  美团HD
//
//  Created by mac527 on 15/10/29.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJRegion : NSObject
/** 区域名字 */
@property (nonatomic, copy) NSString *name;
/** 子区域 */
@property (nonatomic, strong) NSArray *subregions;
@end
