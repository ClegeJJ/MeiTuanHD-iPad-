//
//  CJCategory.h
//  美团HD
//
//  Created by mac527 on 15/10/28.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJCategory : NSObject
/** 类别的名称 */
@property (nonatomic, copy) NSString *name;

/** 子类别:里面都是字符串(子类别的名称) */
@property (nonatomic, strong) NSArray *subcategories;

/** 显示在下拉菜单的小图标 */
@property (nonatomic, copy) NSString *small_highlighted_icon;
@property (nonatomic, copy) NSString *small_icon;

/** 显示在导航栏顶部的大图标 */
@property (nonatomic, copy) NSString *highlighted_icon;
@property (nonatomic, copy) NSString *icon;

/** 显示在地图上的图标 */
@property (nonatomic, copy) NSString *map_icon;
@end
