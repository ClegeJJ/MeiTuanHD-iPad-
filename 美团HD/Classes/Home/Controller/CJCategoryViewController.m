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
#import "CJConst.h"
@interface CJCategoryViewController ()<CJHomeDropDownDataSource,CJHomeDropDownDelegate>

@end

@implementation CJCategoryViewController

- (void)loadView
{
    CJHomeDropDown *dropDown = [CJHomeDropDown dropdown];
    
    dropDown.dataSource = self;
    dropDown.delegate = self;
    self.view = dropDown;
    
    self.preferredContentSize = dropDown.bounds.size;
}

#pragma mark - CJHomeDropDownDelegate
- (void)homeDropDown:(CJHomeDropDown *)homeDropDown didSelectedRowInMainTable:(int)row
{
    
    CJCategory *category = [CJMetaTool categories][row];
    
    if (!category.subcategories.count) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CJCategoryDidChangeNotification object:nil userInfo:@{ CJSelectedCategory : category}];
    }

}

- (void)homeDropDown:(CJHomeDropDown *)homeDropDown didSelectedRowInSubTable:(int)row inMainTabel:(int)mainRow
{
    CJCategory *category = [CJMetaTool categories][mainRow];
    [[NSNotificationCenter defaultCenter] postNotificationName:CJCategoryDidChangeNotification object:nil userInfo:@{CJSelectSubcategoryName : category.subcategories[row],
                        CJSelectedCategory : category}];
}


#pragma mark - CJHomeDropDownDataSource
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
