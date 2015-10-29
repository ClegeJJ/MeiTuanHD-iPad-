//
//  CJCategoryViewController.m
//  美团HD
//
//  Created by mac527 on 15/10/28.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJCategoryViewController.h"
#import "CJCategory.h"
#import "CJHomeDropDown.h"
#import "MJExtension.h"
@interface CJCategoryViewController ()

@end

@implementation CJCategoryViewController

- (void)loadView
{
    CJHomeDropDown *dropDown = [CJHomeDropDown dropdown];
    
    NSArray *categories = [CJCategory objectArrayWithFilename:@"categories.plist"];
    dropDown.categories = categories;
    self.view = dropDown;
    
    self.preferredContentSize = dropDown.bounds.size;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
