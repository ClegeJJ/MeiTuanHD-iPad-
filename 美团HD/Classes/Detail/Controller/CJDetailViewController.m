//
//  CJDetailViewController.m
//  美团HD
//
//  Created by mac527 on 15/10/31.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJDetailViewController.h"
#import "CJConst.h"
#import "UIView+Extension.h"
#import "CJDeal.h"
#import "UIImageView+WebCache.h"
#import "DPAPI.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "CJRestrictions.h"
#import "CJDealTool.h"
@interface CJDetailViewController () <UIWebViewDelegate,DPRequestDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *refundableAnyTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *refundableExpireButton;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
- (IBAction)back:(UIButton *)sender;
- (IBAction)collectButtonClick:(id)sender;


@end

@implementation CJDetailViewController

- (void)viewDidLoad {
    // 基本设置
    self.view.backgroundColor = MTGlobalBg;
    
    self.webView.hidden = YES;
    self.webView.delegate = self;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.deal.deal_h5_url]]];
    
    // 设置基本信息
    self.titleLabel.text = self.deal.title;
    self.descLabel.text = self.deal.desc;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    
    DPAPI *dp = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 页码
    params[@"deal_id"] = self.deal.deal_id;
    [dp requestWithURL:@"v1/deal/get_single_deal" params:params delegate:self];
    
    // 设置收藏状态
    self.collectButton.selected = [CJDealTool isCollected:self.deal];
}
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    self.deal =  [CJDeal objectWithKeyValues:[result[@"deals"] firstObject]];
    
    // 设置退款信息
    self.refundableAnyTimeButton.selected = self.deal.restrictions.is_refundable;
    self.refundableExpireButton.selected = self.deal.restrictions.is_refundable;
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([webView.request.URL.absoluteString isEqualToString:self.deal.deal_h5_url]) {
        // 旧的HTML5页面加载完毕
        NSString *ID = [self.deal.deal_id substringFromIndex:[self.deal.deal_id rangeOfString:@"-"].location + 1];
        NSString *urlStr = [NSString stringWithFormat:@"http://lite.m.dianping.com/group/deal/moreinfo/%@", ID];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    } else { // 详情页面加载完毕
        // 用来拼接所有的JS
        NSMutableString *js = [NSMutableString string];
        // 删除header
        [js appendString:@"var header = document.getElementsByTagName('header')[0];"];
        [js appendString:@"header.parentNode.removeChild(header);"];
        // 删除顶部的购买
        [js appendString:@"var box = document.getElementsByClassName('cost-box')[0];"];
        [js appendString:@"box.parentNode.removeChild(box);"];
        // 删除底部的购买
        [js appendString:@"var buyNow = document.getElementsByClassName('buy-now')[0];"];
        [js appendString:@"buyNow.parentNode.removeChild(buyNow);"];
        
        // 利用webView执行JS
        [webView stringByEvaluatingJavaScriptFromString:js];
        
        // 获得页面
//        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].outerHTML;"];
        // 显示webView
        webView.hidden = NO;
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (IBAction)back:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)collectButtonClick:(id)sender {

    
    if (self.collectButton.isSelected) { // 取消
        [CJDealTool removeCollectDeal:self.deal];
        [MBProgressHUD showSuccess:@"取消收藏成功" toView:self.view];
    }else{ // 收藏
        [CJDealTool addCollectDeal:self.deal];
        [MBProgressHUD showSuccess:@"收藏成功" toView:self.view];
    }
    self.collectButton.selected = !self.collectButton.selected;
}
@end
