//
//  CJDistrictController.m
//  美团HD
//
//  Created by mac527 on 15/10/29.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJRegionController.h"
#import "CJHomeDropDown.h"
#import "UIView+Extension.h"
#import "CJNavigtionController.h"
#import "CJCityViewController.h"
#import "CJRegion.h"
@interface CJRegionController ()<CJHomeDropDownDataSource>
- (IBAction)changeCity:(id)sender;

@end

@implementation CJRegionController

- (void)viewDidLoad {
    
    UIView *title = [self.view.subviews firstObject];
    CJHomeDropDown *dropdowm = [CJHomeDropDown dropdown];
    dropdowm.dataSource = self;
    dropdowm.y = title.height;
    [self.view addSubview:dropdowm];
    
    self.preferredContentSize = CGSizeMake(dropdowm.width, title.height + dropdowm.height);
    
}


- (IBAction)changeCity:(id)sender {
    
    
    CJCityViewController *city = [[CJCityViewController alloc] init];
    CJNavigtionController *nav = [[CJNavigtionController alloc] initWithRootViewController:city];

    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (NSInteger)numberOfRowInMainTableView:(CJHomeDropDown *)homeDropDown
{
    return self.regions.count;
}

- (NSString *)homeDropDown:(CJHomeDropDown *)homeDropDown titleForRowInMainTable:(NSInteger)row
{
    CJRegion *region = self.regions[row];
    
    return region.name;
}

- (NSArray *)homeDropDown:(CJHomeDropDown *)homeDropDown subDataForRowInMainTable:(NSInteger)row
{
    CJRegion *region = self.regions[row];
    
    return region.subregions;
}

@end
