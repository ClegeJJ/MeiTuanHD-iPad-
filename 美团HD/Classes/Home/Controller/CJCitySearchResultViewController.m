//
//  CJCitySearchResultViewController.m
//  美团HD
//
//  Created by mac527 on 15/10/29.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJCitySearchResultViewController.h"
#import "UIView+AutoLayout.h"
#import "CJMetaTool.h"
#import "CJCity.h"
#import "CJConst.h"
#import "MJExtension.h"

@interface CJCitySearchResultViewController ()
@property (nonatomic, strong) NSArray *resultCities;
@end

@implementation CJCitySearchResultViewController



- (void)setSearchText:(NSString *)searchText
{
    _searchText = [searchText copy];
    
    searchText = searchText.lowercaseString;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@",searchText,searchText,searchText];
    
    self.resultCities = [[CJMetaTool cities] filteredArrayUsingPredicate:predicate];
    
    [self.tableView reloadData];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultCities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"contacts";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    CJCity *city = self.resultCities[indexPath.row];
    cell.textLabel.text = city.name;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"共搜索到%d个城市",self.resultCities.count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CJCity *city = self.resultCities[indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CJCityDidChangeNotification object:nil userInfo:@{CJSelectedCityName : city.name}];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
