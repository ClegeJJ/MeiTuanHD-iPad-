//
//  CJHomeViewController.m
//  美团HD
//
//  Created by mac527 on 15/10/28.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJHomeViewController.h"
#import "CJConst.h"
#import "CJCity.h"
#import "CJSort.h"
#import "UIView+Extension.h"
#import "CJHomeNavItem.h"
#import "CJCategoryViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "CJRegionController.h"
#import "CJMetaTool.h"
#import "CJSortViewController.h"
#import "CJCategory.h"
#import "CJRegion.h"
#import "DPAPI.h"
#import "CJDeal.h"
#import "MJExtension.h"
#import "CJDealCell.h"
#import "MJRefresh.h"
#import "UIView+AutoLayout.h"
#import "CJNavigtionController.h"
#import "CJSearchViewController.h"
@interface CJHomeViewController () <DPRequestDelegate>
@property (nonatomic, weak) UIBarButtonItem *categoryItem;
@property (nonatomic, weak) UIBarButtonItem *regionItem;
@property (nonatomic, weak) UIBarButtonItem *sortItem;

@property (nonatomic, strong) UIPopoverController *categoryPop;
@property (nonatomic, strong) UIPopoverController *regionPop;


/** 当前选中的城市名字 */
@property (nonatomic, copy) NSString *selectedCityName;
/** 当前选中的分类名字 */
@property (nonatomic, copy) NSString *selectedCategoryName;
/** 当前选中的区域名字 */
@property (nonatomic, copy) NSString *selectedRegionName;
/** 当前选中的排序 */
@property (nonatomic, strong) CJSort *selectedSort;

@property (nonatomic, strong) NSMutableArray *deals;

/** 记录当前页码 */
@property (nonatomic, assign) int  currentPage;

@property (nonatomic, weak) DPRequest *lastRequest;

@property (nonatomic, weak) UIImageView *noDataView;
@end

@implementation CJHomeViewController

static NSString * const reuseIdentifier = @"deal";


- (NSMutableArray *)deals
{
    if (!_deals) {
        self.deals = [[NSMutableArray alloc] init];
    }
    return _deals;
}
- (UIImageView *)noDataView
{
    if (!_noDataView) {
        // 添加一个"没有数据"的提醒
        UIImageView *noDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_deals_empty"]];
        [self.view addSubview:noDataView];
        [noDataView autoCenterInSuperview];
        self.noDataView = noDataView;
    }
    return _noDataView;
}
- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(305, 305);
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = MTGlobalBg;
    
    self.collectionView.alwaysBounceVertical = YES;
    
    
    [self setUpLeftItems];
    
    [self setUpRightItems];
    
    [self setUpNotification];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CJDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - 监听通知
- (void)cityChange:(NSNotification *)notification
{
    self.selectedCityName = notification.userInfo[CJSelectedCityName];
    
    CJHomeNavItem *navItem = (CJHomeNavItem *)self.regionItem.customView;
    [navItem setTitle:[NSString stringWithFormat:@"%@ - 全部", self.selectedCityName]];
    [navItem setSubtitle:nil];
    
    [self loadNewDeals];
    
}

- (void)categoryChange:(NSNotification *)notification
{
    CJCategory *category = notification.userInfo[CJSelectedCategory];
    NSString *subcategoryName = notification.userInfo[CJSelectSubcategoryName];
    
    if (subcategoryName == nil || [subcategoryName isEqualToString:@"全部"]) { // 点击的数据没有子分类
        self.selectedCategoryName = category.name;
    } else {
        self.selectedCategoryName = subcategoryName;
    }
    if ([self.selectedCategoryName isEqualToString:@"全部分类"]) {
        self.selectedCategoryName = nil;
    }
    
    // 1.更换顶部item的文字
    CJHomeNavItem *topItem = (CJHomeNavItem *)self.categoryItem.customView;
    [topItem setIcon:category.icon highlight:category.highlighted_icon];
    [topItem setTitle:category.name];
    [topItem setSubtitle:subcategoryName];
    
    // 2.关闭popover
    [self.categoryPop dismissPopoverAnimated:YES];
    
    // 3.刷新表格数据
    [self loadNewDeals];
    
}

- (void)regionChange:(NSNotification *)notification
{
    CJRegion *region = notification.userInfo[CJSelectedRegion];
    NSString *subregionName = notification.userInfo[CJSelectSubRegionName];
    
    if (subregionName == nil || [subregionName isEqualToString:@"全部"]) {
        self.selectedRegionName = region.name;
    } else {
        self.selectedRegionName = subregionName;
    }
    if ([self.selectedRegionName isEqualToString:@"全部"]) {
        self.selectedRegionName = nil;
    }
    
    // 1.更换顶部item的文字
    CJHomeNavItem *topItem = (CJHomeNavItem *)self.regionItem.customView;
    [topItem setTitle:[NSString stringWithFormat:@"%@ - %@", self.selectedCityName, region.name]];
    [topItem setSubtitle:subregionName];
    
    // 2.关闭popover
    [self.regionPop dismissPopoverAnimated:YES];
    
    // 3.刷新表格数据
    [self loadNewDeals];
}

- (void)sortChange:(NSNotification *)notification
{
    self.selectedSort = notification.userInfo[CJSelectedSort];
    // 1.更换顶部排序item的文字
    CJHomeNavItem *topItem = (CJHomeNavItem *)self.sortItem.customView;
    [topItem setSubtitle:self.selectedSort.label];

    // 3.刷新表格数据
    [self loadNewDeals];
}


#pragma mark - 加载团购数据
- (void)loadDeals
{
    DPAPI *dp = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 城市
    params[@"city"] = self.selectedCityName;
    // 每页的条数
    params[@"limit"] = @30;
    
    params[@"page"] = @(self.currentPage);
    
    // 分类(类别)
    if (self.selectedCategoryName) {
        params[@"category"] = self.selectedCategoryName;
    }
    // 区域
    if (self.selectedRegionName) {
        params[@"region"] = self.selectedRegionName;
    }
    // 排序
    if (self.selectedSort) {
        params[@"sort"] = @(self.selectedSort.value);
    }
    self.lastRequest = [dp requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
    
}

- (void)loadNewDeals
{
    self.currentPage = 1;
    [self loadDeals];
}

- (void)loadMoreDeals
{
    self.currentPage ++ ;
    [self loadDeals];
}


- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    if (request != self.lastRequest) return;
    
    NSArray *dealData = [CJDeal objectArrayWithKeyValuesArray:result[@"deals"]];

    
    if (self.currentPage == 1) {
        [self.deals removeAllObjects];
    }
    [self.deals addObjectsFromArray:dealData];
    
    
    
    [self.collectionView reloadData];
    
    [self.collectionView.footer endRefreshing];
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"请求失败--%@", error);
}

#pragma mark -初始化导航栏按钮
- (void)setUpLeftItems
{
    UIBarButtonItem *logeIeam = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStyleDone target:nil action:nil];
    logeIeam.enabled = NO;
    CJHomeNavItem *category = [CJHomeNavItem Item];
    [category addtarget:self action:@selector(categoryClick:)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:category];
    self.categoryItem = categoryItem;
    
    
    CJHomeNavItem *region = [CJHomeNavItem Item];
    [region addtarget:self action:@selector(regionClick:)];
    UIBarButtonItem *regionItem = [[UIBarButtonItem alloc] initWithCustomView:region];
    self.regionItem = regionItem;
    
    CJHomeNavItem *sort = [CJHomeNavItem Item];
    [sort addtarget:self action:@selector(sortClick:)];
    [sort setTitle:@"排序"];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sort];
    self.sortItem = sortItem;
    
    self.navigationItem.leftBarButtonItems = @[logeIeam,categoryItem,regionItem,sortItem];

}
- (void)setUpRightItems
{
    UIBarButtonItem *map = [UIBarButtonItem itemWithTarget:nil action:nil image:@"icon_map" highImage:@"icon_map_highlighted"];
    map.customView.width = 60;
    
    UIBarButtonItem *search = [UIBarButtonItem itemWithTarget:self action:@selector(searchButtonClick) image:@"icon_search" highImage:@"icon_search_highlighted"];
    search.customView.width = 60;
    
    self.navigationItem.rightBarButtonItems = @[map,search];

}
- (void)setUpNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChange:) name:CJCityDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryChange:) name:CJCategoryDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(regionChange:) name:CJRegionDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortChange:) name:CJSortDidChangeNotification object:nil];
}
#pragma mark - 监听屏幕旋转
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    int col = (size.width == 1024 ? 3 : 2);
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    CGFloat inset = (size.width - layout.itemSize.width * col) / (col + 1);
    
    layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    layout.minimumLineSpacing = inset;
}

#pragma mark - 监听导航栏按钮点击
- (void)categoryClick:(UIButton *)button
{
    // 显示分类菜单
    UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:[[CJCategoryViewController alloc] init]];

    [pop presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.categoryPop = pop;
}

- (void)regionClick:(UIButton *)button
{
    CJRegionController *region = [[CJRegionController alloc] init];
    if (self.selectedCityName) {
        // 获得当前选中城市
        CJCity *city = [[[CJMetaTool cities] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", self.selectedCityName]] firstObject];
        region.regions = city.regions;
    }
    
    UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:region];
    
    [pop presentPopoverFromBarButtonItem:self.regionItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.regionPop = pop;
}

- (void)sortClick:(UIButton *)button
{
    CJSortViewController *sortVc = [[CJSortViewController alloc] init];
    UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:sortVc];
    
    [pop presentPopoverFromBarButtonItem:self.sortItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}


- (void)searchButtonClick
{
    CJSearchViewController *search = [[CJSearchViewController alloc] init];
    
    CJNavigtionController *nav= [[CJNavigtionController alloc] initWithRootViewController:search];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    [self viewWillTransitionToSize:CGSizeMake(collectionView.width, 0) withTransitionCoordinator:nil];

    self.noDataView.hidden = (self.deals.count != 0);
    
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CJDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.deal = self.deals[indexPath.row];
    
    return cell;
}

@end
