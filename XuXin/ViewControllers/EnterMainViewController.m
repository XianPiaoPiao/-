//
//  EnterMainViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/31.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "EnterMainViewController.h"

@interface EnterMainViewController ()

@end

@implementation EnterMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    
}
-(void)creatUI{
    UIImageView * HaiDuimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, 232)];
    HaiDuimageView.image = [UIImage imageNamed:@""];
    [self.view addSubview:HaiDuimageView];
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
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
