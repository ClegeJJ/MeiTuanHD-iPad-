//
//  CJCity.h
//  美团HD
//
//  Created by mac527 on 15/10/29.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJCity : NSObject
/** 城市名字 */
@property (nonatomic, copy) NSString *name;
/** 城市名字的拼音 */
@property (nonatomic, copy) NSString *pinYin;
/** 城市名字的拼音声母 */
@property (nonatomic, copy) NSString *pinYinHead;
/** 区域(存放的都是MTRegion模型) */
@property (nonatomic, strong) NSArray *regions;
@end
