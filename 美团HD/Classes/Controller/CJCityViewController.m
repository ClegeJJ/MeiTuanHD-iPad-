//
//  CJCityViewController.m
//  美团HD
//
//  Created by mac527 on 15/10/29.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJCityViewController.h"
#import "CJCityGroup.h"
#import "MJExtension.h"
#import "CJConst.h"
#import "CJCitySearchResultViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+AutoLayout.h"
@interface CJCityViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIButton *Cover;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *cityGroups;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) CJCitySearchResultViewController *searchResult;
- (IBAction)coverClick:(UIButton *)sender;
@end

@implementation CJCityViewController


- (CJCitySearchResultViewController *)searchResult
{
    if (_searchResult == nil) {
        CJCitySearchResultViewController *searchResult = [[CJCitySearchResultViewController alloc] init];
        [self addChildViewController:searchResult];
        self.searchResult = searchResult;
        
        [self.view addSubview:self.searchResult.view];
        [self.searchResult.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.searchResult.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar withOffset:10];
    }
    return _searchResult;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"切换城市";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(close) image:@"btn_navigation_close" highImage:@"btn_navigation_close_hl"];
    
    self.searchBar.tintColor = [UIColor blackColor];
    
    self.cityGroups = [CJCityGroup objectArrayWithFilename:@"cityGroups.plist"];
    
}
#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cityGroups.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CJCityGroup *group = self.cityGroups[section];
    return group.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"contacts";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
       
    }
    
    CJCityGroup *group = self.cityGroups[indexPath.section];
    cell.textLabel.text = group.cities[indexPath.row];
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    CJCityGroup *group = self.cityGroups[section];
    return group.title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CJCityGroup *group = self.cityGroups[indexPath.section];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CJCityDidChangeNotification object:nil userInfo:@{CJSelectedCityName : group.cities[indexPath.row]}];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.cityGroups valueForKeyPath:@"title"];

}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [searchBar setShowsCancelButton:YES animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
            self.Cover.alpha = 0.5;
    }];
    
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield_hl"]];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield"]];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.Cover.alpha = 0.0;
    }];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.searchResult.view.hidden = YES;
    searchBar.text = nil;
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length) {
        self.searchResult.view.hidden = NO;
        self.searchResult.searchText = searchText;
    } else{
        self.searchResult.view.hidden = YES;
    }

}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

- (IBAction)coverClick:(UIButton *)sender {
    [self.searchBar resignFirstResponder];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
