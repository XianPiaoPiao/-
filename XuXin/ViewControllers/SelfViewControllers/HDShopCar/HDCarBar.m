//
//  HDCarBar.m
//  XuXin
//
//  Created by xuxin on 16/9/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//
static NSInteger const BalanceButtonTag = 120;

static NSInteger const DeleteButtonTag = 121;

static NSInteger const SelectButtonTag = 122;

#import "HDCarBar.h"
#import "UILabel+Extension.h"

@interface UIImage (JS)

+ (UIImage *)imageWithColor:(UIColor *)color ;

@end

@implementation UIImage (JS)

+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end

@interface HDCarBar ()

@end

@implementation HDCarBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBarUI];
    }
    return self;
}

- (void)setBarUI{
    
    self.backgroundColor = [UIColor clearColor];
    /* 背景 */
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effectView.userInteractionEnabled = NO;
    effectView.frame = self.bounds;
    [self addSubview:effectView];
    
    CGFloat wd = ScreenW*2/7;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
    lineView.backgroundColor  = [UIColor colorWithHexString:BackColor];
    [self addSubview:lineView];
    /* 结算 */
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    [button setTitle:@"结算" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(ScreenW-wd, 0, wd, self.frame.size.height)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    button.enabled = NO;
    button.tag = BalanceButtonTag;
    [self addSubview:button];
    _balanceButton = button;
    /* 删除 */
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    [button1 setTitle:@"删除" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [button1 setFrame:CGRectMake(ScreenW-wd, 0, wd, self.frame.size.height)];
    button1.enabled = NO;
    button1.hidden = YES;
    button1.tag = DeleteButtonTag;
    [self addSubview:button1];
    _deleteButton = button1;
    /* 全选 */
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setImage:[UIImage imageNamed:@"btn_shopcart_radio_off.png"] forState:UIControlStateNormal];
    [button3 setImage:[UIImage imageNamed:@"exchange_selected@3x"] forState:UIControlStateSelected];
    [button3 setTitle:@"全选"
             forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blackColor]
                  forState:UIControlStateNormal];
    [button3 setFrame:CGRectMake(0, 0, 78, self.frame.size.height)];
    [button3 setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [button3 setImagePositionWithType:SSImagePositionTypeLeft spacing:5];

    button3.tag = SelectButtonTag;
    [self addSubview:button3];
    _selectAllButton = button3;
    /* 价格 */
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(wd, 0, ScreenW-wd*2-5, self.frame.size.height)];
    label1.text = [NSString stringWithFormat:@"总计￥:%@",@(00.00)];
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont systemFontOfSize:14];
    label1.textAlignment = NSTextAlignmentRight;
    [self addSubview:label1];
    _allMoneyLabel = label1;
    
    /* assign value */
    WEAK
    [RACObserve(self, money) subscribeNext:^(NSNumber *x) {
        STRONG
        self.allMoneyLabel.text = [NSString stringWithFormat:@"总计￥:%.2f",x.floatValue];
    }];
    
    [RACObserve(self, integral) subscribeNext:^(NSNumber *x) {
        STRONG
        [self.allMoneyLabel labelWithIntegral:x.integerValue money:self.money];
        //.text = [NSString stringWithFormat:@"%@ %.2f积分",_allMoneyLabel.text,x.floatValue];
    }];
    
    /*  RAC BLIND  */
    RAC(self.balanceButton,enabled) = [RACSignal combineLatest:@[RACObserve(self.selectAllButton, selected),
                                                                 RACObserve(self, money),
                                                                 RACObserve(self, integral)]
                                                        reduce:^id(NSNumber *isSelect,NSNumber *moeny,NSNumber *integral){
                                                            return @(isSelect.boolValue||moeny.floatValue>0||integral.floatValue);
                                                        }];
}


@end

