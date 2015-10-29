//
//  CJHomeViewController.m
//  美团HD
//
//  Created by mac527 on 15/10/28.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJHomeViewController.h"
#import "CJConst.h"
#import "UIView+Extension.h"
#import "CJHomeNavItem.h"
#import "CJCategoryViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "CJDistrictController.h"
@interface CJHomeViewController ()
@property (nonatomic, weak) UIBarButtonItem *categoryItem;
@property (nonatomic, weak) UIBarButtonItem *districtItem;
@property (nonatomic, weak) UIBarButtonItem *sortItem;
@end

@implementation CJHomeViewController

static NSString * const reuseIdentifier = @"Cell";


- (instancetype)init
{
    UICollectionViewLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = MTGlobalBg;
    
    [self setUpLeftItems];
    
    [self setUpRightItems];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChange:) name:CJCityDidChangeNotification object:nil];
    
}
- (void)cityChange:(NSNotification *)notification
{
    NSString *cityName = notification.userInfo[CJSelectedCityName];
    
    CJHomeNavItem *navItem = (CJHomeNavItem *)self.districtItem.customView;
    [navItem setTitle:[NSString stringWithFormat:@"%@ - 全部", cityName]];
    [navItem setSubtitle:nil];
    
}

- (void)setUpLeftItems
{
    UIBarButtonItem *logeIeam = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStyleDone target:nil action:nil];
    logeIeam.enabled = NO;
    CJHomeNavItem *category = [CJHomeNavItem Item];
    [category addtarget:self action:@selector(categoryClick:)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:category];
    self.categoryItem = categoryItem;
    
    
    CJHomeNavItem *district = [CJHomeNavItem Item];
    [district addtarget:self action:@selector(districtClick:)];
    UIBarButtonItem *districtItem = [[UIBarButtonItem alloc] initWithCustomView:district];
    self.districtItem = districtItem;
    
    CJHomeNavItem *sort = [CJHomeNavItem Item];
    [sort addtarget:self action:@selector(sortClick:)];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sort];
    self.sortItem = sortItem;
    
    self.navigationItem.leftBarButtonItems = @[logeIeam,categoryItem,districtItem,sortItem];

}
- (void)setUpRightItems
{
    UIBarButtonItem *map = [UIBarButtonItem itemWithTarget:nil action:nil image:@"icon_map" highImage:@"icon_map_highlighted"];
    map.customView.width = 60;
    
    UIBarButtonItem *search = [UIBarButtonItem itemWithTarget:nil action:nil image:@"icon_search" highImage:@"icon_search_highlighted"];
    search.customView.width = 60;
    
    self.navigationItem.rightBarButtonItems = @[map,search];

}

- (void)categoryClick:(UIButton *)button
{
    // 显示分类菜单
    UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:[[CJCategoryViewController alloc] init]];

    [pop presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)districtClick:(UIButton *)button
{
    // 显示分类菜单
    UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:[[CJDistrictController alloc] init]];
    
    [pop presentPopoverFromBarButtonItem:self.districtItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (void)sortClick:(UIButton *)button
{
    
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
