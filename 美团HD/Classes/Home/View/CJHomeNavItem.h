//
//  CJHomeNavItem.h
//  美团HD
//
//  Created by mac527 on 15/10/28.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJHomeNavItem : UIView
+ (instancetype)Item;

- (void)setTitle:(NSString *)title;
- (void)setSubtitle:(NSString *)Subtitle;

- (void)setIcon:(NSString *)icon highlight:(NSString *)highlight;


- (void)addtarget:(id)target action:(SEL)action;
@end
