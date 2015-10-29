//
//  CJHomeNavItem.m
//  美团HD
//
//  Created by mac527 on 15/10/28.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJHomeNavItem.h"
@interface CJHomeNavItem ()
@property (weak, nonatomic) IBOutlet UIButton *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@end
@implementation CJHomeNavItem
+ (instancetype)Item
{
    return [[[NSBundle mainBundle] loadNibNamed:@"CJHomeNavItem" owner:nil options:nil] firstObject];
}
- (void)addtarget:(id)target action:(SEL)action
{
    [self.iconView addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}
- (void)setSubtitle:(NSString *)Subtitle
{
    self.subTitle.text = Subtitle;
}

- (void)setIcon:(NSString *)icon highlight:(NSString *)highlight
{
    [self.iconView setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [self.iconView setImage:[UIImage imageNamed:highlight] forState:UIControlStateHighlighted];

}
@end
