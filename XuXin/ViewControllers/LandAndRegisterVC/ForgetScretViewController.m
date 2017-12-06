//
//  ForgetScretViewController.m
//  XuXin
//
//  Created by xuxin on 16/9/13.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "ForgetScretViewController.h"
#import "LandingViewController.h"
#import "RegisterOKViewController.h"
#import "RegisterField.h"
#import "XuXinField.h"
#import "BankListViewController.h"
#define timeCount 60
static int count = 0;
@interface ForgetScretViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UIButton *verifyRightView; //获取验证码按钮

@end

@implementation ForgetScretViewController{
    NSTimer * _showRepeatBttonTimer;
    NSTimer * _updateTime; //更新倒计时label
    XuXinField * _phoneNumberField;
    RegisterField * _testField;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    [self creatNavgationBar];
    
    [self creatUI];
}
-(void)creatNavgationBar{
    
    self.navigationController.navigationBarHidden = YES;
    UIView * navBegView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, KNAV_TOOL_HEIGHT)];
    navBegView.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+self.StatusBarHeight, 100, 44)];
    label.center = CGPointMake(ScreenW/2.0f, 42+self.StatusBarHeight);
    [label setText:@"忘记密码"];
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
-(void)creatUI{
    
    //创建右视图
    _verifyRightView = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 90, 30)];
    _verifyRightView.titleLabel.textAlignment = 1;
    [_verifyRightView setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_verifyRightView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _verifyRightView.backgroundColor = [UIColor colorWithHexString:MainColor];
    _verifyRightView.layer.cornerRadius = 15;

    
    [_verifyRightView.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    //添加点击事件
      [_verifyRightView addTarget:self action:@selector(sendNumberAction) forControlEvents:UIControlEventTouchUpInside];
    
      UIView * leftBgView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW -100, 0+self.StatusBarHeight, 100, 50)];
      leftBgView.backgroundColor = [UIColor whiteColor];
    
      [leftBgView addSubview:_verifyRightView];

      _phoneNumberField = [[XuXinField alloc] initWithFrame:CGRectMake(0, 74+self.StatusBarHeight, ScreenW, 50)];
    
      [_phoneNumberField setKeyboardType: UIKeyboardTypePhonePad];
   
      _phoneNumberField.backgroundColor = [UIColor whiteColor];
    
     [_phoneNumberField setPlaceholder:@"手机号码"];
    
     [self.view addSubview:_phoneNumberField];
    
    //验证码
    _testField = [[RegisterField alloc] initWithFrame:CGRectMake(0, 125+self.StatusBarHeight, ScreenW, 50)];
    [_testField setKeyboardType: UIKeyboardTypeNumberPad];
    _testField.returnKeyType=UIReturnKeyGo;
    
    _testField.backgroundColor = [UIColor whiteColor];
    
    _testField.rightViewMode = UITextFieldViewModeAlways;
    
    _testField.rightView = leftBgView;
    
    [_testField setPlaceholder:@"输入验证码"];
    [self.view addSubview:_testField];
    
    //下一步
    UIButton * nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 200+self.StatusBarHeight, ScreenW - 20, 50)];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = 25;
    nextBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
    [self.view addSubview:nextBtn];
    
    //点击事件
    [nextBtn addTarget:self action:@selector(regiesterCompelete) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark ---发送验证码

-(void)sendNumberAction{
    //
    
    if(_phoneNumberField.text.length != 11){
        
        [self showStaus:@"手机号码不正确"];
        
    } else{
        
        [SVProgressHUD showWithStatus:@"请稍等"];
        
        __weak typeof(self)weakself = self;
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        param[@"phone"] = _phoneNumberField.text;
        param[@"verifyCodeType"] =[NSString stringWithFormat:@"%ld",forgetPassWordType];
        
        [weakself POST:VerifyCodeUrl parameters:param success:^(id responseObject) {
            NSString * str = responseObject[@"isSucc"];
            if ([str intValue] == 1) {
                
                [weakself getVerify];
                
            }else{
                
                [self showStaus:responseObject[@"msg"]];
            }

        } failure:^(NSError *error) {
            
        }];
              
    }
    
}


//收回键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

- (void)getVerify
{
    [_showRepeatBttonTimer invalidate]; //
    [_updateTime invalidate];
    self.verifyRightView.backgroundColor = [UIColor colorWithHexString:WordLightColor];

    count = 0;
    // 显示重新发送按钮
    NSTimer *showRepeatButtonTimer=[NSTimer scheduledTimerWithTimeInterval:timeCount target:self selector:@selector(showRepeatButton) userInfo:nil
                                                                   repeats:YES];
    // 倒计时label
    NSTimer * updateTime = [NSTimer scheduledTimerWithTimeInterval:1
                                                            target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    _showRepeatBttonTimer = showRepeatButtonTimer;
    _updateTime = updateTime;
}

/**
 *  显示重新发送按钮
 */
-(void)showRepeatButton{
    
    self.verifyRightView.backgroundColor = [UIColor colorWithHexString:MainColor];

    [self.verifyRightView setTitle:@"重新发送" forState:UIControlStateNormal];
    self.verifyRightView.userInteractionEnabled = YES;
    [self.verifyRightView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_showRepeatBttonTimer invalidate];
    return;
}
-(void)updateTime
{
    count++;
    if (count >= timeCount)
    {
        [_updateTime invalidate];
        return;
    }
    
    NSString *updateTimeStr =[NSString stringWithFormat:@"%@%i%@",NSLocalizedString(@"", nil),timeCount-count,NSLocalizedString(@"秒可重发", nil)];
    [self.verifyRightView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.verifyRightView.userInteractionEnabled = NO;
    [self.verifyRightView setTitle:updateTimeStr forState:UIControlStateNormal];
    
}
#pragma mark ----注册按钮
-(void)regiesterCompelete{
    
    if(_phoneNumberField.text.length != 11){
        
        [self showStaus:@"手机号码不正确"];
        
    } else if(_phoneNumberField.text.length == 11 && _testField.text.length == 6){
        //验证验证码
        [self verifyVrifedCode];
        
    } else{
        
        [self showStaus:@"验证码长度有误"];
    }
    
    
}
#pragma mark --- 验证验证码
-(void)verifyVrifedCode{
    
    [SVProgressHUD showWithStatus:@"请稍等"];
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"phone"] = _phoneNumberField.text;
    param[@"verifyCodeType"] = [NSString stringWithFormat:@"%ld",forgetPassWordType];
    param[@"verifyCode"] =  _testField.text;
    //验证验证码
    param[@"isVerify"] = @"1";
    
    [weakself POST:VerifyCodeUrl parameters:param success:^(id responseObject) {
        
        NSString *  issucc = responseObject[@"isSucc"];
        int  i = [issucc intValue];
        if (i == 1) {
            
            //忘记密码
            RegisterOKViewController * forgetVC = [[RegisterOKViewController alloc] init];
            forgetVC.phoneNumber =   _phoneNumberField.text;
            forgetVC.verifyCode =  _testField.text ;
            forgetVC.category = forgetPassWordType;
            
            [weakself.navigationController pushViewController:forgetVC animated:YES];
            
        }

    } failure:^(NSError *error) {
        
    }];
    
}

@end
