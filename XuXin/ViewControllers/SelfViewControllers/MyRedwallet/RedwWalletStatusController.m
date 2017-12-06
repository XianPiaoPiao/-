//
//  RedwWalletStatusController.m
//  XuXin
//
//  Created by xuxin on 16/12/8.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "RedwWalletStatusController.h"
#import "MyInvationWalletViewController.h"
@interface RedwWalletStatusController ()
@property (weak, nonatomic) IBOutlet UIButton *activityBtn;

@end

@implementation RedwWalletStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityBtn.layer.cornerRadius = 4;
}
- (IBAction)activityRedWallet:(id)sender {
    MyInvationWalletViewController * invatationVC = [[MyInvationWalletViewController alloc] init];
    [self.navigationController pushViewController:invatationVC animated:YES];
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
