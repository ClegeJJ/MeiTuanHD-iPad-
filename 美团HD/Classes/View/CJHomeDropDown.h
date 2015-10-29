//
//  CJHomeDropDown.h
//  美团HD
//
//  Created by mac527 on 15/10/28.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJHomeDropDown : UIView
+ (instancetype)dropdown;

/**
 *  分类数据
 */
@property (nonatomic, strong) NSArray *categories;
@end
