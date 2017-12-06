//
//  GroupShopCarController.m
//  XuXin
//
//  Created by xuxin on 17/3/15.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "GroupShopCarController.h"

@interface GroupShopCarController ()

@end

@implementation GroupShopCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shopCarType = 2;
    //编辑
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBottom) name:@"online" object:nil];
    //完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickupBottom) name:@"onlineOff" object:nil];
    
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
}
-(void)showBottom{
    
    [UIView animateWithDuration:0.4 animations:^{
        
     //   self.cartBar.frame = CGRectMake(0, screenH -50, ScreenW, 50);
        
        self.edictBotomView.frame = CGRectMake(0 , screenH , ScreenW, 50);
    }];
}
-(void)pickupBottom{
    
    
    [UIView animateWithDuration:0.4 animations:^{
        
      //  self.cartBar.frame = CGRectMake(0, screenH , ScreenW, 50);
        
        self.edictBotomView.frame = CGRectMake(0, screenH -50, ScreenW, 50);
    }];
}


@end
