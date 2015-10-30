//
//  CJCityGroup.h
//  美团HD
//
//  Created by mac527 on 15/10/29.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJCityGroup : NSObject
/** 这组的标题 */
@property (nonatomic, copy) NSString *title;
/** 这组的所有城市 */
@property (nonatomic, strong) NSArray *cities;
@end
