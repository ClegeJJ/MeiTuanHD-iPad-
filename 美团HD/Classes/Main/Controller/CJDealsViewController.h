//
//  CJDealsViewController.h
//  美团HD
//
//  Created by mac527 on 15/10/30.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJDealsViewController : UICollectionViewController
/**
 *  设置请求参数:交给子类去实现
 */
- (void)setupParams:(NSMutableDictionary *)params;
@end
