//
//  CJDealsViewController.m
//  美团HD
//
//  Created by mac527 on 15/10/30.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJDealsViewController.h"
#import "DPAPI.h"
#import "CJDealCell.h"
#import "CJConst.h"
#import "MJRefresh.h"
#import "UIView+AutoLayout.h"
#import "MJExtension.h"
#import "CJDeal.h"
#import "UIView+Extension.h"
@interface CJDealsViewController () <DPRequestDelegate>
@property (nonatomic, strong) NSMutableArray *deals;

/** 记录当前页码 */
@property (nonatomic, assign) int  currentPage;

@property (nonatomic, weak) DPRequest *lastRequest;

@property (nonatomic, weak) UIImageView *noDataView;
@end

@implementation CJDealsViewController

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
    [self.collectionView registerNib:[UINib nibWithNibName:@"CJDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDeals)];
    self.collectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];
}

- (void)loadDeals
{
    DPAPI *dp = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[@"limit"] = @30;
    params[@"page"] = @(self.currentPage);
    

    [self setupParams:params];
    
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
    [self.collectionView.header endRefreshing];
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"请求失败--%@", error);
    if (request != self.lastRequest) return;
    
    // 1.提醒失败
//    [MBProgressHUD showError:@"网络繁忙,请稍后再试" toView:self.view];
    
    // 2.结束刷新
    [self.collectionView.header endRefreshing];
    [self.collectionView.footer endRefreshing];
    
    // 3.如果是上拉加载失败了
    if (self.currentPage > 1) {
        self.currentPage--;
    }
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
