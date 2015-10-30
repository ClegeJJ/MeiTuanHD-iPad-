//
//  CJHomeDropDown.m
//  美团HD
//
//  Created by mac527 on 15/10/28.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJHomeDropDown.h"
#import "CJHomeDropDownMainCell.h"
#import "CJHomeDropDownSubCell.h"
@interface CJHomeDropDown () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;
@property (nonatomic, assign) NSInteger *seledtedRow;

@end
@implementation CJHomeDropDown

+ (instancetype)dropdown
{
    return [[[NSBundle mainBundle] loadNibNamed:@"CJHomeDropDown" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.mainTableView) {
        return [self.dataSource numberOfRowInMainTableView:self];
    }else{
        return [self.dataSource homeDropDown:self subDataForRowInMainTable:self.seledtedRow].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    
    if (tableView == self.mainTableView) {
        cell = [CJHomeDropDownMainCell cellWithTableView:tableView];
        cell.textLabel.text = [self.dataSource homeDropDown:self titleForRowInMainTable:indexPath.row];
        
        
        if ([self.dataSource respondsToSelector:@selector(homeDropDown:iconForRowInMainTable:)]) {
            cell.imageView.image = [UIImage imageNamed:[self.dataSource homeDropDown:self iconForRowInMainTable:indexPath.row]];
        }
        if ([self.dataSource respondsToSelector:@selector(homeDropDown:selectedIconForRowInMainTable:)]) {
            cell.imageView.highlightedImage = [UIImage imageNamed:[self.dataSource homeDropDown:self selectedIconForRowInMainTable:indexPath.row]];
        }
        
        NSArray *subData = [self.dataSource homeDropDown:self subDataForRowInMainTable:indexPath.row];
        
        if (subData.count){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    } else{
        cell = [CJHomeDropDownSubCell cellWithTableView:tableView];
     
        cell.textLabel.text = [self.dataSource homeDropDown:self subDataForRowInMainTable:self.seledtedRow][indexPath.row];

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) {
        self.seledtedRow = indexPath.row;
        [self.subTableView reloadData];
        
        if ([self.delegate respondsToSelector:@selector(homeDropDown:didSelectedRowInMainTable:)]) {
            [self.delegate homeDropDown:self didSelectedRowInMainTable:indexPath.row];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(homeDropDown:didSelectedRowInSubTable:inMainTabel:)]) {
            [self.delegate homeDropDown:self didSelectedRowInSubTable:indexPath.row inMainTabel:self.seledtedRow];
        }
    }
    
}

@end
