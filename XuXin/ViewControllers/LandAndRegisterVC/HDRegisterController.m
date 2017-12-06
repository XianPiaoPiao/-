//
//  HDRegisterController.m
//  XuXin
//
//  Created by xuxin on 16/12/13.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "HDRegisterController.h"
#import "LandingViewController.h"
#import "RegisterOKViewController.h"
#import "RegisterField.h"
#import "BankListViewController.h"
#import "HDMainViewController.h"
#import "HtmWalletPaytypeController.h"
#define timeCount 60
static int count = 0;
@interface HDRegisterController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UIButton *verifyRightView; //获取验证码按钮
@property (nonatomic ,copy)NSString * phone;
@property (nonatomic ,copy)NSString * password;
@property (nonatomic ,copy)NSString * code;
@property (nonatomic ,copy)NSString * recmondPhoneNumber;
@end

@implementation HDRegisterController{
    
    NSTimer * _showRepeatBttonTimer;
    NSTimer * _updateTime; //更新倒计时label
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    [self creatNavgationBar];
  
    [self creatUI];
    
    if (self.userId) {
        
        [self getUserPhoneNumber];
        
    }
}
-(void)getUserPhoneNumber{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    param[@"id"] = self.userId;
    
    [self POST:findUserNameByIdUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str integerValue] == 1) {
            
            _recmondPhoneNumber = responseObject[@"result"][@"userName"];
            UITextField * recmondTextField = [self.view viewWithTag:buttonTag + 4];
            recmondTextField.text = _recmondPhoneNumber;
            
            recmondTextField.textColor = [UIColor grayColor];
            
            recmondTextField.enabled = NO;
            
        }else{
            
            [self showStaus:@"推荐人不存在"];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)creatNavgationBar{
    
    self.navigationController.navigationBarHidden = NO;
    
    [self addNavgationTitle:@"注册"];
    
    [self addBackBarButtonItem];
    

}

-(void)creatUI{
    
    CGFloat fieldH = 50;
    //创建右视图
    _verifyRightView = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 90, 30)];
    _verifyRightView.titleLabel.textAlignment = 1;
    [_verifyRightView setTitle:@"发送验证码" forState:UIControlStateNormal];
    _verifyRightView.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _verifyRightView.backgroundColor = [UIColor colorWithHexString:MainColor];
    _verifyRightView.layer.cornerRadius = 15;
    [_verifyRightView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_verifyRightView addTarget:self action:@selector(sendRegisterNumberAction) forControlEvents:UIControlEventTouchUpInside];
 
    NSArray * array = @[@"手机号码",@"输入验证码",@"请输入登录密码",@"确认登录密码",@"输入推荐人电话"];
    NSArray * imageArray =@[@"zhuce_shouji@3x",@"zhuce_yanzhengma",@"zhuce_mima@3x",@"zhuce_queren@3x",@"zhuce_tuijianren@2x",];
    for (int i = 0; i< 5; i++) {
      
       UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 68+self.StatusBarHeight + ((fieldH+1) * i), ScreenW , fieldH)];
        UIButton * leftImage =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
        
        if (i == 0) {
            
            [textField setKeyboardType:UIKeyboardTypePhonePad];

        }else if (i == 1) {
            
            textField.rightViewMode = UITextFieldViewModeAlways;
            
            [textField setKeyboardType:UIKeyboardTypePhonePad];
            
            UIView * leftBgView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW -100, 0, 100, 50)];
            leftBgView.backgroundColor = [UIColor whiteColor];
            [leftBgView addSubview:_verifyRightView];
            //
            textField.rightView = leftBgView;
                //分割线
            
        }else if (i ==2){
            
            textField.secureTextEntry = YES;
            
        }else if (i == 3){
            textField.secureTextEntry = YES;

        }else if (i== 4){
            
            [textField setKeyboardType:UIKeyboardTypePhonePad];

        }

        textField.backgroundColor = [UIColor whiteColor];
        ;
        [leftImage setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        textField.placeholder = array[i];
        textField.font  =[UIFont systemFontOfSize:16];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.tag = buttonTag + i;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.leftView = leftImage;
        [self.view addSubview:textField];

    }
    //
    
    UILabel * agreeLabel  = [[UILabel alloc] initWithFrame:CGRectMake(10, 340+self.StatusBarHeight, 80, 20)];
    
    UIButton * agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(90, 340+self.StatusBarHeight, 90,20)];
    
    [agreeBtn setTitle:@"<用户协议>" forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(checkUser) forControlEvents:UIControlEventTouchDown];
    
    [agreeBtn setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateNormal];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    agreeLabel.text = @"注册即同意";
    agreeLabel.font = [UIFont systemFontOfSize:15];
    agreeLabel.textColor = [UIColor colorWithHexString:WordDeepColor];
    agreeLabel.textAlignment = 0;
    
    [self.view addSubview:agreeLabel];
    [self.view addSubview:agreeBtn];
    //下一步
    UIButton * nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 390+self.StatusBarHeight, ScreenW - 20, 50)];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = 25;
    nextBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
    [self.view addSubview:nextBtn];
    //点击事件

    [nextBtn addTarget:self action:@selector(regiesterCompelete) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark ---发送验证码
-(void)sendRegisterNumberAction{
    
  UITextField * field =  [self.view viewWithTag:buttonTag];
        _phone = field.text;
    
    if(_phone.length != 11){
        
        [self showStaus:@"手机号码不正确"];
        
    } else{
        
        [SVProgressHUD showWithStatus:@"请稍等"];
        __weak typeof(self)weakself = self;
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        param = [NSMutableDictionary dictionary];
        param[@"phone"] = _phone;
        
        param[@"verifyCodeType"] = [NSString stringWithFormat:@"%ld",registerType];
        
        [weakself POST:VerifyCodeUrl parameters:param success:^(id responseObject) {
            
            NSString * str = responseObject[@"isSucc"];
            if ([str intValue] == 1) {
                
                [weakself getVerify];
                
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
    
    UITextField * passwordField = [self.view viewWithTag:buttonTag + 2];
    UITextField * codeField = [self.view viewWithTag:buttonTag + 1];
    UITextField * competeField = [self.view viewWithTag:buttonTag +3];
    UITextField * recmondField = [self.view viewWithTag:buttonTag + 4];
    
    _password = passwordField.text;
    _code = codeField.text;
    _recmondPhoneNumber = recmondField.text;
    
    if(_phone.length != 11){
        
      
        [self showStaus:@"手机号码不正确"];
        
    }else if (_code.length != 6){
       
        [self showStaus:@"验证码长度有误"];

    }else if (_password != competeField.text){
        
        
        [self showStaus:@"两次输入的密码不一致"];

    }else if (_password.length < 6){
        
       
        [self showStaus:@"输入的密码长度小于6位"];

    }else{
        
        //验证验证码
        [self showStaus:@"请稍等"];
        [self verifyVrifedCode];
        
    }
    
    
}
#pragma mark --- 验证验证码
-(void)verifyVrifedCode{
  
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"phone"] = _phone;
    param[@"password"] =_password;
    
    param[@"verifyCode"] = _code;
    param[@"ref_name"] = _recmondPhoneNumber;
    
    [weakself POST:registerUrl parameters:param success:^(id responseObject) {
        
        NSString *  issucc = responseObject[@"isSucc"];
        int  i = [issucc intValue];
        
        if (i == 1) {
            
            [self showStaus:@"注册成功"];
        
          //  NSString * str = _phone;
          //  self.block(str);
            
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_phone,@"phoneNumber", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"phoneNumber" object:nil userInfo:dic];
            
            //扫码进入
            if (_pushType == 1) {
                
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [self goLanding];
                    
                });
            
            }else{
                
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                });
            }
       
            
        } 

    } failure:^(NSError *error) {
        
    }];
 
}

-(void)checkUser{
    
    //查看协议
    HtmWalletPaytypeController * htmlVC = [[HtmWalletPaytypeController alloc] init];
    htmlVC.requestUrl = registrAgreementUrl;
    htmlVC.htmlType = registrAgreementType;
    [self.navigationController pushViewController:htmlVC animated:YES];
}

@end
