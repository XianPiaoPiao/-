//
//  CordChargeViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/30.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "CordChargeViewController.h"
#import "PayTypeViewController.h"
@interface CordChargeViewController ()

@end

@implementation CordChargeViewController{
    UITextField * _numberField;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBar];
    [self creatUI];
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:@"efefef"];
}
-(void)creatNavgationBar{
    [self addNavgationTitle:@"账户充值"];
    [self addBackBarButtonItem];
}
-(void)creatUI{
    
   _numberField = [[UITextField alloc] initWithFrame:CGRectMake(0, 74+self.StatusBarHeight, ScreenW, 45)];
    
    _numberField.backgroundColor = [UIColor whiteColor];
    [_numberField setKeyboardType: UIKeyboardTypeDecimalPad];
    [self.view addSubview:_numberField];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+self.StatusBarHeight, 50, 20)];
    label.textAlignment = 1;
    label.text = @"金额";
    [label setTextColor:[UIColor blackColor]];
     [_numberField setLeftView:label];
    [label setFont:[UIFont systemFontOfSize:16]];
    //设置field的左视图
    _numberField.leftViewMode = UITextFieldViewModeAlways;
    _numberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_numberField setPlaceholder:@"请输入充值金额"];
    [_numberField setFont:[UIFont systemFontOfSize:15]];

    
    UIButton * nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 220+self.StatusBarHeight, ScreenW - 80, 50)];
    nextBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
    nextBtn.layer.cornerRadius = 25;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(junmpNextVC) forControlEvents:UIControlEventTouchDown];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
}
-(void)junmpNextVC{
    
    if (_numberField.text.length > 0) {
        PayTypeViewController * payTypeVC =[[PayTypeViewController alloc] init];
        payTypeVC.moneyNumber = _numberField.text;
        [self.navigationController pushViewController:payTypeVC animated:YES];
    }else{
        
        [self showStaus:@"请输入充值的金额"];
    }
}
-(void)ReturnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
