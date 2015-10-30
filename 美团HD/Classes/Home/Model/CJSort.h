//
//  CJSort.h
//  美团HD
//
//  Created by mac527 on 15/10/30.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJSort : NSObject
/** 排序名称 */
@property (nonatomic, copy) NSString *label;
/** 排序的值(将来发给服务器) */
@property (nonatomic, assign) int value;
@end
