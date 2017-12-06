//
//  RegistViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/31.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "RegistViewController.h"
#import "LandingViewController.h"
#import "RegisterOKViewController.h"
#import "RegisterField.h"
#import "BankListViewController.h"
#define timeCount 60
static int count = 0;
@interface RegistViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UIButton *verifyRightView; //获取验证码按钮

@end

@implementation RegistViewController{
    NSTimer * _showRepeatBttonTimer;
    NSTimer * _updateTime; //更新倒计时label
    UILabel * _phoneNumberField;
    RegisterField * _testField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //数据请求Url设置
   // self.requestUrl = [NSString stringWithFormat:@"%@",VerifyCodeUrl];
    
    //设置背景颜色
    [self creatNavgationBar];
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    [self creatUI];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)creatNavgationBar{

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
    
    //创建右视图
    _verifyRightView = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 90, 30)];
    _verifyRightView.titleLabel.textAlignment = 1;
    [_verifyRightView setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_verifyRightView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    
    [_verifyRightView.titleLabel setFont:[UIFont systemFontOfSize:14]];
    _verifyRightView.backgroundColor = [UIColor colorWithHexString:MainColor];
    _verifyRightView.layer.cornerRadius = 15;
    //添加点击事件
    [_verifyRightView addTarget:self action:@selector(sendNumberAction) forControlEvents:UIControlEventTouchUpInside];
    //
    _phoneNumberField = [[UILabel alloc] initWithFrame:CGRectMake(10, 74, ScreenW, 40)];
    [self.view addSubview:_phoneNumberField];
    _phoneNumberField.font = [UIFont systemFontOfSize:15];
    NSString * userPhone = [User defalutManager].userName;
    NSString * str;
    NSString * str2;
    if (userPhone.length > 0) {
        
       str  = [userPhone substringWithRange:NSMakeRange(0, 3)];
       str2  =[userPhone substringWithRange:NSMakeRange(7, 4)];
    }
    
    if (_type == 2) {
   
        _phoneNumberField.text =[NSString stringWithFormat:@"你正在为%@****%@重置登录密码",str,str2];

    }else if (_type == 3){
        
      _phoneNumberField.text =[NSString stringWithFormat:@"你正在为%@****%@重置支付密码",str,str2];
    }else if (_type == 4){
        
    _phoneNumberField.text =[NSString stringWithFormat:@"你正在为%@****%@添加银行卡",str,str2];
    }else if (_type ==5){
        
    _phoneNumberField.text =[NSString stringWithFormat:@"你正在为%@****%@解除绑定银行卡",str,str2];
    }
    
    UIView * leftBgView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW -100, 0, 100, 50)];
    leftBgView.backgroundColor = [UIColor whiteColor];
    [leftBgView addSubview:_verifyRightView];
    
    //验证码
    _testField = [[RegisterField alloc] initWithFrame:CGRectMake(0, 115, ScreenW, 50)];
    [_testField setKeyboardType: UIKeyboardTypeNumberPad];
    _testField.returnKeyType=UIReturnKeyGo;

    _testField.backgroundColor = [UIColor whiteColor];
    
    _testField.rightViewMode = UITextFieldViewModeAlways;
    
    _testField.rightView = leftBgView;
    
    [_testField setPlaceholder:@"输入验证码"];
    [self.view addSubview:_testField];
    //下一步
    UIButton * nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, ScreenW - 20, 50)];
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
    
        [SVProgressHUD showWithStatus:@"请稍等"];
        //
        __weak typeof(self)weakself = self;
        _param = [NSMutableDictionary dictionary];
        _param[@"phone"] = [User defalutManager].userName;
        _param[@"verifyCodeType"] =[NSString stringWithFormat:@"%ld",self.type];
        [weakself POST:VerifyCodeUrl parameters:_param success:^(id responseObject) {
            
            NSString * str = responseObject[@"isSucc"];
            
            if ([str intValue] == 1) {
                
                [weakself getVerify];
                
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
    [self.verifyRightView setTitle:@"重新发送" forState:UIControlStateNormal];
    self.verifyRightView.userInteractionEnabled = YES;
    self.verifyRightView.backgroundColor = [UIColor colorWithHexString:MainColor];
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
    
  if(_testField.text.length == 6){
 
      if (self.type == 5) {
          
          //解除绑定银行卡
          [self upblindBankID];
          
      }else if (self.type == 4){
          
          //添加银行卡
        //  [self addBankID];
      }
         else{
          //验证验证码
          [self verifyVrifedCode];
      }
      
    }

}


#pragma mark ---解除绑定银行卡
-(void)upblindBankID{
    
    [SVProgressHUD showWithStatus:@"请稍等"];
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    //验证验证码
   
    param[@"verifyCode"] = _testField.text;
    
    param[@"bankCardId"] = _bankCardId;
    [weakself POST:unbindBankCardUrl parameters:param success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSString *  issucc = responseObject[@"isSucc"];
        
        if ([issucc intValue] == 1) {
            
            
            [self showStaus:@"解除绑定银行卡成功"];
          //  [SVProgressHUD dismissWithDelay:2];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteBankOK" object:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                
                UIViewController * viewCrl = self.navigationController.viewControllers[2];
                [weakself.navigationController popToViewController:viewCrl animated:YES];
            });
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
   
}
#pragma mark --- 验证验证码
-(void)verifyVrifedCode{
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
   
    //验证验证码
    param[@"verifyCodeType"] =[NSString stringWithFormat:@"%ld",self.type];
    param[@"verifyCode"] = _testField.text;
    param[@"isVerify"] = @"1";
    param[@"phone"] = [User defalutManager].userName;
    [weakself POST:VerifyCodeUrl parameters:param success:^(id responseObject) {
        NSString *  issucc = responseObject[@"isSucc"];
        int  i = [issucc intValue];
        if (i == 1) {
            //修改支付密码
            RegisterOKViewController * registOKVC =[[RegisterOKViewController alloc] init];
            
            registOKVC.verifyCode = _testField.text ;
            registOKVC.category = 3;
            
            [weakself.navigationController pushViewController:registOKVC animated:YES];
            
        }

    } failure:^(NSError *error) {
        
    }];

    
}
@end
