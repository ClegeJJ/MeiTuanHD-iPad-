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
#import "MJRefresh.h"
@interface CJSearchViewController () <UISearchBarDelegate>

@end

@implementation CJSearchViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
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

#pragma mark - 搜索框代理
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // 进入下拉刷新状态, 发送请求给服务器
    [self.collectionView.header beginRefreshing];
    
    // 退出键盘
    [searchBar resignFirstResponder];
}

- (void)setupParams:(NSMutableDictionary *)params
{
    params[@"city"] = self.cityName;
    UISearchBar *bar = (UISearchBar *)self.navigationItem.titleView;
    params[@"keyword"] = bar.text;
}
@end
