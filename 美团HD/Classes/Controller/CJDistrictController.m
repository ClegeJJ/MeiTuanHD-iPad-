//
//  CJDistrictController.m
//  美团HD
//
//  Created by mac527 on 15/10/29.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJDistrictController.h"
#import "CJHomeDropDown.h"
#import "UIView+Extension.h"
#import "CJNavigtionController.h"
#import "CJCityViewController.h"
@interface CJDistrictController ()
- (IBAction)changeCity:(id)sender;

@end

@implementation CJDistrictController

- (void)viewDidLoad {
    
    UIView *title = [self.view.subviews firstObject];
    CJHomeDropDown *dropdowm = [CJHomeDropDown dropdown];
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
@end
