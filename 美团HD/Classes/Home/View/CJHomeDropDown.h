//
//  CJHomeDropDown.h
//  美团HD
//
//  Created by mac527 on 15/10/28.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CJHomeDropDown;
@protocol CJHomeDropDownDataSource <NSObject>

- (NSInteger)numberOfRowInMainTableView:(CJHomeDropDown *)homeDropDown;

- (NSString *)homeDropDown:(CJHomeDropDown *)homeDropDown titleForRowInMainTable:(NSInteger)row;

- (NSArray *)homeDropDown:(CJHomeDropDown *)homeDropDown subDataForRowInMainTable:(NSInteger)row;
@optional

- (NSString *)homeDropDown:(CJHomeDropDown *)homeDropDown iconForRowInMainTable:(NSInteger)row;

- (NSString *)homeDropDown:(CJHomeDropDown *)homeDropDown selectedIconForRowInMainTable:(NSInteger)row;
@end

@protocol CJHomeDropDownDelegate <NSObject>

- (void)homeDropDown:(CJHomeDropDown *)homeDropDown didSelectedRowInMainTable:(int)row;

- (void)homeDropDown:(CJHomeDropDown *)homeDropDown didSelectedRowInSubTable:(int)row inMainTabel:(int)mainRow;

@end


@interface CJHomeDropDown : UIView
+ (instancetype)dropdown;

@property (nonatomic, weak) id<CJHomeDropDownDataSource> dataSource;

@property (nonatomic, weak) id<CJHomeDropDownDelegate> delegate;


@end
