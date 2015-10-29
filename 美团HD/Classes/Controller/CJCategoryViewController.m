//
//  CJCategoryViewController.m
//  美团HD
//
//  Created by mac527 on 15/10/28.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJCategoryViewController.h"
#import "CJCategory.h"
#import "CJMetaTool.h"
#import "CJHomeDropDown.h"
#import "MJExtension.h"
@interface CJCategoryViewController ()<CJHomeDropDownDataSource>

@end

@implementation CJCategoryViewController

- (void)loadView
{
    CJHomeDropDown *dropDown = [CJHomeDropDown dropdown];
    
    dropDown.dataSource = self;
    self.view = dropDown;
    
    self.preferredContentSize = dropDown.bounds.size;
}


- (NSInteger)numberOfRowInMainTableView:(CJHomeDropDown *)homeDropDown
{
    return [CJMetaTool categories].count;
}

- (NSString *)homeDropDown:(CJHomeDropDown *)homeDropDown titleForRowInMainTable:(NSInteger)row
{
    CJCategory *cat = [CJMetaTool categories][row];
    return cat.name;
}
- (NSString *)homeDropDown:(CJHomeDropDown *)homeDropDown iconForRowInMainTable:(NSInteger)row
{
    CJCategory *cat = [CJMetaTool categories][row];
    return cat.small_icon;
}

- (NSString *)homeDropDown:(CJHomeDropDown *)homeDropDown selectedIconForRowInMainTable:(NSInteger)row
{
    CJCategory *cat = [CJMetaTool categories][row];
    return cat.small_highlighted_icon;
}

- (NSArray *)homeDropDown:(CJHomeDropDown *)homeDropDown subDataForRowInMainTable:(NSInteger)row
{
    CJCategory *cat = [CJMetaTool categories][row];
    return cat.subcategories;
}



@end
