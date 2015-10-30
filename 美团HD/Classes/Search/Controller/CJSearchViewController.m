//
//  CJSearchViewController.m
//  美团HD
//
//  Created by mac527 on 15/10/30.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJSearchViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "CJConst.h"
@interface CJSearchViewController () <UISearchBarDelegate>

@end

@implementation CJSearchViewController

- (void)viewDidLoad {
    
    self.view.backgroundColor = MTGlobalBg;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"请输入关键词";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
  
}


- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
