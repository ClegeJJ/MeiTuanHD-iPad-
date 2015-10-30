//
//  CJSortViewController.m
//  美团HD
//
//  Created by mac527 on 15/10/30.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJSortViewController.h"
#import "CJSort.h"
#import "CJMetaTool.h"
#import "UIView+Extension.h"
#import "CJConst.h"
@interface CJSortButton : UIButton
@property (nonatomic, strong) CJSort *sort;
@end

@implementation CJSortButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)setSort:(CJSort *)sort
{
    _sort = sort;
    
    [self setTitle:sort.label forState:UIControlStateNormal];
}


@end

@interface CJSortViewController ()

@end

@implementation CJSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *sorts = [CJMetaTool sorts];
    NSUInteger count = sorts.count;
    CGFloat btnW = 100;
    CGFloat btnH = 30;
    CGFloat btnX = 15;
    CGFloat btnStartY = 15;
    CGFloat btnMargin = 15;
    CGFloat height = 0;
    for (NSUInteger i = 0; i<count; i++) {
        CJSortButton *button = [[CJSortButton alloc] init];
        // 传递模型
        button.sort = sorts[i];
        button.width = btnW;
        button.height = btnH;
        button.x = btnX;
        button.y = btnStartY + i * (btnH + btnMargin);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.view addSubview:button];
        
        height = CGRectGetMaxY(button.frame);
    }
    
    // 设置控制器在popover中的尺寸
    CGFloat width = btnW + 2 * btnX;
    height += btnMargin;
    self.preferredContentSize = CGSizeMake(width, height);

}

- (void)buttonClick:(UIButton *)button {
    
    CJSortButton *btn = (CJSortButton *)button;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CJSortDidChangeNotification object:nil userInfo:@{
                                                                                                   CJSelectedSort : btn.sort
                                                                                                   }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



@end
