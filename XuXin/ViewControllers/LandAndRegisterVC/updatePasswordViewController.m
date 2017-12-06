//
//  updatePasswordViewController.m
//  XuXin
//
//  Created by xuxin on 16/10/20.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "updatePasswordViewController.h"
#import "LandingViewController.h"
#import "XuXinField.h"

@interface updatePasswordViewController ()

@end

@implementation updatePasswordViewController{
    XuXinField * _secrectField;
    XuXinField * _testField;
    XuXinField * _repeatField;
    UIAlertView * _registOKAlterView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatNavgationBar];
    //背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    [self creatUI];
}
-(void)creatNavgationBar{
    
    UIView * navBegView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 64)];
    navBegView.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 44)];
    label.center = CGPointMake(ScreenW/2.0f, 42);
    [label setText:@"修改登录密码"];
  
    label.textAlignment = 1;
    
    UIButton * button= [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 60, 44)];
    [button setImagePositionWithType:SSImagePositionTypeLeft spacing:6];
    
    [button setImage:[UIImage imageNamed:@"fanhui@3x"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"fanhui@3x"] forState:UIControlStateNormal];
    //添加点击事件
    [button addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchDown];
    [navBegView addSubview:label];
    [navBegView addSubview:button];
    [self.view addSubview:navBegView];
}

-(void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatUI{
        
        _secrectField = [[XuXinField alloc] initWithFrame:CGRectMake(0, 74, ScreenW, 50)];
        _secrectField.backgroundColor = [UIColor whiteColor];
        [_secrectField setPlaceholder:@"旧密码"];
        _secrectField.secureTextEntry = YES;
        [self.view addSubview:_secrectField];
    
        _testField = [[XuXinField alloc] initWithFrame:CGRectMake(0, 125, ScreenW, 50)];
        _testField.backgroundColor = [UIColor whiteColor];
        
        
        [_testField setPlaceholder:@"新密码"];
        _testField.secureTextEntry = YES;
        [self.view addSubview:_testField];
    
    _repeatField = [[XuXinField alloc] initWithFrame:CGRectMake(0, 176, ScreenW, 50)];
    _repeatField.backgroundColor = [UIColor whiteColor];
    
    
    [_repeatField setPlaceholder:@"再次输入密码"];
    _repeatField.secureTextEntry = YES;
    [self.view addSubview:_repeatField];
        //下一步
        UIButton * nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 250, ScreenW - 20, 50)];
        [nextBtn setTitle:@"确认提交" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        nextBtn.layer.cornerRadius = 25;
        nextBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
        [self.view addSubview:nextBtn];
        //添加事件
        [nextBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchDown];
        
}

-(void)sureAction{
    
     __weak typeof(self)weakself = self;

    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"oldPwd"] = _secrectField.text;
    param[@"newPwd"] = _testField.text;


if (_secrectField.text.length >= 6 && [_testField.text isEqualToString:_repeatField.text] == YES) {
    
    [SVProgressHUD showWithStatus:@"请稍等"];
    [weakself POST:updatePwdUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            [self showStaus:@"修改登录密码成功"];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sex"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"birthDay"];
            //synchronize的作用就是命令直接同步到文件里
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToLand" object:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismissWithDelay:1];
                
                LandingViewController * landVC = [[LandingViewController alloc] init];
                [self.navigationController pushViewController:landVC animated:YES];
            });
            
            
        }
        
    } failure:^(NSError *error) {
        
    }];
  
}else if (_testField.text.length < 6){
    
    [self showStaus:@"密码长度不够"];

}
else if([_testField.text isEqualToString:_repeatField.text] == NO){
    
    [self showStaus:@"两次输入的密码不一致"];

}
    
}




@end
