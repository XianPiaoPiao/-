//
//  ChargeSureViewController.m
//  XuXin
//
//  Created by xuxin on 16/10/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "ChargeSureViewController.h"

@interface ChargeSureViewController ()
@property (weak, nonatomic) IBOutlet UILabel *balabceNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargeNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *secretTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation ChargeSureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBar];
     [self initUI];
}
-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"我的银行卡"];
    [self addBackBarButtonItem];
}

-(void)initUI{

    self.sureBtn.layer.cornerRadius = 6;
    self.sureBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
    self.chargeNumberLabel.text =[NSString stringWithFormat:@"￥%.2f", [_moneyNumber floatValue]];
    self.balabceNumberLabel.text = [NSString stringWithFormat:@"余额 ￥%.2f",    [User defalutManager].balance];

    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 20)];
    label.textAlignment = 1;
    label.text = @"支付密码";
    [label setTextColor:[UIColor blackColor]];
    [_secretTextField setLeftView:label];
    [label setFont:[UIFont systemFontOfSize:16]];
    //设置field的左视图
    _secretTextField.leftViewMode = UITextFieldViewModeAlways;
    _secretTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_secretTextField setPlaceholder:@"请输入支付密码"];
    [_secretTextField setFont:[UIFont systemFontOfSize:15]];
}
- (IBAction)sureBtnAction:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
