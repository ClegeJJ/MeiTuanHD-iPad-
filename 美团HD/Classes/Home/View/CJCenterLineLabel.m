//
//  CJCenterLineLabel.m
//  美团HD
//
//  Created by mac527 on 15/10/30.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJCenterLineLabel.h"

@implementation CJCenterLineLabel

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIRectFill(CGRectMake(0,rect.size.height * 0.5 , rect.size.width, 1));

}
@end
