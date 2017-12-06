//
//  ChangePayPasswordViewController.m
//  XuXin
//
//  Created by xuxin on 16/10/18.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "ChangePayPasswordViewController.h"

@interface ChangePayPasswordViewController ()

@end

@implementation ChangePayPasswordViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //
    self.type = changePasswordType;
    
    [self creatNavgationBar];

    // Do any additional setup after loading the view.
}

-(void)creatNavgationBar{
    
    self.navigationController.navigationBarHidden = YES;
    UIView * navBegView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, KNAV_TOOL_HEIGHT)];
    navBegView.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+self.StatusBarHeight, 100, 44)];
    label.center = CGPointMake(ScreenW/2.0f, 42+self.StatusBarHeight);
    [label setText:@"手机验证"];
    label.textAlignment = 1;
    
    UIButton * button= [[UIButton alloc] initWithFrame:CGRectMake(0, 20+self.StatusBarHeight, 60, 44)];
    [button setImagePositionWithType:SSImagePositionTypeLeft spacing:6];
    
    [button setImage:[UIImage imageNamed:@"fanhui@3x"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"fanhui@3x"] forState:UIControlStateNormal];
    //添加点击事件
    [button addTarget:self action:@selector(returnToStingVC) forControlEvents:UIControlEventTouchUpInside];
    [navBegView addSubview:label];
    [navBegView addSubview:button];
    [self.view addSubview:navBegView];
}

-(void)returnToStingVC{
    [self.navigationController popViewControllerAnimated:YES];
}




@end
