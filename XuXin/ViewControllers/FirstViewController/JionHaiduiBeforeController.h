//
//  JionHaiduiBeforeController.h
//  XuXin
//
//  Created by xuxin on 16/12/5.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"
#import "InsetLabel.h"
@interface JionHaiduiBeforeController : BaseViewContrlloer
@property (weak, nonatomic) IBOutlet InsetLabel *mainContentLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (weak, nonatomic) IBOutlet InsetLabel *threeContentLabel;
@property (weak, nonatomic) IBOutlet InsetLabel *twoContentLabel;
@property (weak, nonatomic) IBOutlet InsetLabel *oneContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end
