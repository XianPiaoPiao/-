//
//  ForgetSecretViewController.m
//  XuXin
//
//  Created by xuxin on 16/9/13.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "RegisterOKViewController.h"
#import "LandingViewController.h"
#import "XuXinField.h"
@interface RegisterOKViewController ()<UIAlertViewDelegate>

@end

@implementation RegisterOKViewController{
    XuXinField * _secrectField;
    XuXinField * _testField;
    UIAlertView * _registOKAlterView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBar];
    [self creatUI];
    //判断赋值
    if (self.category == 1) {
        
        self.requestUrl = registerUrl;
        
    }else if (self.category == 2){
        
        self.requestUrl = forgetUrl;
        
    }else if (self.category == 3){
        
        self.requestUrl = updatePayPwdUrl;
    }
    //密码模式
    _testField.secureTextEntry = YES;
    _secrectField.secureTextEntry = YES;
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
}
#pragma mark ----创建视图
-(void)creatUI{
    
    _secrectField = [[XuXinField alloc] initWithFrame:CGRectMake(0, 74, ScreenW, 50)];
    _secrectField.backgroundColor = [UIColor whiteColor];
    [_secrectField setPlaceholder:@"新密码"];
    
    [self.view addSubview:_secrectField];
    _testField = [[XuXinField alloc] initWithFrame:CGRectMake(0, 125, ScreenW, 50)];
    _testField.backgroundColor = [UIColor whiteColor];
    
 
    [_testField setPlaceholder:@"确认新密码"];
    [self.view addSubview:_testField];

    //下一步
    UIButton * nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, ScreenW - 20, 50)];
    [nextBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = 25;
    nextBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
    [self.view addSubview:nextBtn];
    //添加事件
    [nextBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchDown];

}
-(void)creatNavgationBar{
    
    UIView * navBegView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 64)];
    navBegView.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 44)];
    label.center = CGPointMake(ScreenW/2.0f, 42);
    if (self.category == 1) {
        [label setText:@"设置登录密码"];

    }else if (self.category == 2){
        [label setText:@"忘记登录密码"];

    }else if (self.category == 3){
        [label setText:@"修改支付密码"];

    }
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

#pragma mark ---数据请求
-(void)sureAction{
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
   

    
    param[@"verifyCode"] = weakself.verifyCode;
    if (self.category == 1) {
        
        param[@"password"] = _secrectField.text;
        param[@"phone"] = [User defalutManager].userName;

        
    }else if (self.category == 2){
        //忘记密码
        param[@"newPwd"] = _testField.text;
        param[@"phone"] = _phoneNumber;

    }else if (self.category == 3){
        
        param[@"newPwd"] = _testField.text;
        param[@"phone"] = [User defalutManager].userName;

    }
    
    if (_secrectField.text.length >= 6) {
        
        
        if ([_secrectField.text isEqualToString: _testField.text]) {
            
            [SVProgressHUD showWithStatus:@"请稍等"];

            [weakself POST:self.requestUrl parameters:param success:^(id responseObject) {
                
                NSString * str = responseObject[@"isSucc"];
                int i = [str intValue];
                
                if (i == 1) {
                    
                    if (self.category == 1) {
                        
                        [self showStaus:@"设置登录密码成功"];
                        
                    }else if (self.category == 2){
                        
                        [self showStaus:@"修改登录密码成功"];
                        
                    }else if (self.category == 3){
                        
                        [self showStaus:@"修改支付密码成功"];
                        
                    }
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        NSArray * array = self.navigationController.viewControllers;
                        
                        UIViewController * viewCrl = self.navigationController.viewControllers[array.count - 3];
                        
                        [self.navigationController popToViewController:viewCrl animated:YES];
                    });
                    
                }
            } failure:^(NSError *error) {
                
                
            }];
         
        } else{
            
            [self showStaus:@"二次输入的密码不一致"];
            
        }
        
    } else{
        
        [self showStaus:@"密码长度不够"];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if (alertView == _registOKAlterView) {
            
//            NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.phoneNumber,@"phoneNumber", nil];
//         
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"phoneNumber" object:nil userInfo:dic];
          
        }
    
        
    }
}

 


@end
