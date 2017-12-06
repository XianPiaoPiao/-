//
//  MyInvationWalletViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/30.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MyInvationWalletViewController.h"
#import "HtmWalletPaytypeController.h"
#import "ReconmendFriendsViewController.h"
@interface MyInvationWalletViewController ()
@property (weak, nonatomic) IBOutlet UILabel *invateFirendsBtn;

@end

@implementation MyInvationWalletViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBar];
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    //
    self.InvateFriendBtn.layer.cornerRadius = 5;
}
-(void)creatNavgationBar{
    self.navigationController.navigationBarHidden = NO;
    [self addNavgationTitle:@"我的红包"];
    [self addBackBarButtonItem];
}
- (IBAction)activeExpalinAction:(id)sender {
    HtmWalletPaytypeController * walletExpainVC = [[HtmWalletPaytypeController alloc] init];
    walletExpainVC.requestUrl = redBag_ruleHtml;
    walletExpainVC.htmlType = activiteHtmlType;
    [self.navigationController pushViewController:walletExpainVC animated:YES];
}
-(void)returnAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)invateFriendsAction:(id)sender {
    
    ReconmendFriendsViewController * MyQrcodeVC =[[ReconmendFriendsViewController alloc] init];
    [self.navigationController pushViewController:MyQrcodeVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
