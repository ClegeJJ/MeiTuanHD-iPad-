//
//  CJHomeDropDown.m
//  美团HD
//
//  Created by mac527 on 15/10/28.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJHomeDropDown.h"
#import "CJCategory.h"
#import "CJHomeDropDownMainCell.h"
#import "CJHomeDropDownSubCell.h"
@interface CJHomeDropDown () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;
@property (nonatomic, strong) CJCategory *seledtedCategory;

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
        return self.categories.count;
    }else{
        return self.seledtedCategory.subcategories.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    
    if (tableView == self.mainTableView) {
        cell = [CJHomeDropDownMainCell cellWithTableView:tableView];
        CJCategory *cat = self.categories[indexPath.row];
        cell.textLabel.text = cat.name;
        cell.imageView.image = [UIImage imageNamed:cat.small_icon];
        if (cat.subcategories){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    } else{
        cell = [CJHomeDropDownSubCell cellWithTableView:tableView];
     
        cell.textLabel.text = self.seledtedCategory.subcategories[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) {
        self.seledtedCategory = self.categories[indexPath.row];
        [self.subTableView reloadData];
    }
}

@end
