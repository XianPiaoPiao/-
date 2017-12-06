//
//  SendVerificationcodeController.m
//  XuXin
//
//  Created by xuxin on 16/12/6.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "SendVerificationcodeController.h"
#import "RegisterField.h"
#define timeCount 60
static int count = 0;
@interface SendVerificationcodeController ()
@property (nonatomic, strong) UIButton *verifyRightView; //获取验证码按钮

@end

@implementation SendVerificationcodeController{
    RegisterField * _verifyCationCodeField;
    NSTimer * _showRepeatBttonTimer;
    NSTimer * _updateTime; //更新倒计时label
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    [self creatNavgationBar];
    [self creatUI];
    // Do any additional setup after loading the view.
}
-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"短信验证"];
    
    [self addBackBarButtonItem];
}
-(void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatUI{
    
    UILabel * phoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(10, 74, ScreenW - 20, 20)];
    phoneNumber.textAlignment = 0;
    phoneNumber.font = [UIFont systemFontOfSize:14];
    phoneNumber.text = [NSString stringWithFormat:@"验证码发送至手机%@",_phone];
    [self.view addSubview:phoneNumber];
    //创建右视图
    _verifyRightView = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 90, 30)];
    _verifyRightView.backgroundColor = [UIColor colorWithHexString:MainColor];
    _verifyRightView.layer.cornerRadius = 15;
    _verifyRightView.titleLabel.textAlignment = 1;
    [_verifyRightView setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_verifyRightView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_verifyRightView addTarget:self action:@selector(sendVerifcation) forControlEvents:UIControlEventTouchUpInside];
    //分割线
//    UIView * seperateView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW - 110, 110, 1, 30)];
//    seperateView.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    [_verifyRightView.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
  
    //验证码
    _verifyCationCodeField = [[RegisterField alloc] initWithFrame:CGRectMake(0 , 105, ScreenW, 50)];
    _verifyCationCodeField.font = [UIFont systemFontOfSize:14];
    [_verifyCationCodeField setKeyboardType: UIKeyboardTypeNumberPad];
    _verifyCationCodeField.returnKeyType=UIReturnKeyGo;
    
    UIView * leftBgView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW -100, 0, 100, 50)];
    leftBgView.backgroundColor = [UIColor whiteColor];
    [leftBgView addSubview:_verifyRightView];
    
    _verifyCationCodeField.backgroundColor = [UIColor whiteColor];
    
    _verifyCationCodeField.rightViewMode = UITextFieldViewModeAlways;
    
    _verifyCationCodeField.rightView = leftBgView;
    [_verifyCationCodeField setPlaceholder:@"短信验证"];
    [self.view addSubview:_verifyCationCodeField];
 //   [self.view addSubview:seperateView];
    //下一步
    UIButton * nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, ScreenW - 20, 50)];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = 25;
    nextBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
    [self.view addSubview:nextBtn];
    //点击事件
    [nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
}
//发送验证码
-(void)sendVerifcation{
    //
        [SVProgressHUD showWithStatus:@"请稍等"];
        __weak typeof(self)weakself = self;
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        param[@"phone"] = _phone;
        param[@"verifyCodeType"] = @"4";
        
        [weakself POST:VerifyCodeUrl parameters:param success:^(id responseObject) {
            
            [weakself getVerify];
            
        } failure:^(NSError *error) {
            
            
    }];

}
//验证验证码
-(void)nextBtnAction{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"bankCardNumber"] = _bankCardNumber;
    param[@"bankId"] = _bankId;
    param[@"trueName"] = _trueName;
    param[@"iDCard"] = _iDCard;
    param[@"phone"] = _phone;
    param[@"verifyCode"] = _verifyCationCodeField.text; //验证码，String（6位）
    [weakself POST:bindBankCardUrl parameters:param success:^(id responseObject) {
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            [self showStaus:@"添加提款方式成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addCard" object:nil];
                
                UIViewController *viewCtl = self.navigationController.viewControllers[2];
                
                [self.navigationController popToViewController:viewCtl animated:YES];
            });
          
            
        }

    } failure:^(NSError *error) {
        
        
    }];
  
}

//收回键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}

- (void)getVerify
{
    self.verifyRightView.backgroundColor = [UIColor colorWithHexString:WordLightColor];
    [_showRepeatBttonTimer invalidate]; //
    [_updateTime invalidate];
    
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
    [self.verifyRightView setTitleColor:[UIColor colorWithHexString:BackColor] forState:UIControlStateNormal];
    self.verifyRightView.userInteractionEnabled = NO;
    [self.verifyRightView setTitle:updateTimeStr forState:UIControlStateNormal];
    
}

@end
