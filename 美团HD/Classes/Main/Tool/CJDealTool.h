//
//  CJDealTool.h
//  美团HD
//
//  Created by mac527 on 15/10/31.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

@class CJDeal;
#import <Foundation/Foundation.h>
@interface CJDealTool : NSObject

+ (NSArray *)collectDeals:(int)page;
+ (int)collectDealsCount;
/**
 *  收藏一个团购
 */
+ (void)addCollectDeal:(CJDeal *)deal;
/**
 *  取消收藏一个团购
 */
+ (void)removeCollectDeal:(CJDeal *)deal;

/**
 *  团购是否收藏
 */
+ (BOOL)isCollected:(CJDeal *)deal;
@end
