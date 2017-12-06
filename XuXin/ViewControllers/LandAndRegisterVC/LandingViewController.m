//
//  LandingViewController.m
//  登陆界面
//
//

#import "LandingViewController.h"
#import "HDRegisterController.h"
#import "RegisterOKViewController.h"
#import "ForgetScretViewController.h"
#import "XXTabBarController.h"
#import <CommonCrypto/CommonDigest.h>

@interface LandingViewController ()<UITextFieldDelegate>

@end

@implementation LandingViewController
{
    UITextField * _IDfield;
    UITextField * _secretField ;
    UIView * _bgView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MTA trackPageViewBegin:@"LandingViewController"];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    if (self.returnTexBlock != nil) {
        
        self.returnTexBlock(_IDfield.text);
    }
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"LandingViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPhoneNumber:) name:@"phoneNumber" object:nil];
    [self creatNavgationBar];
    
    [self creatUI];

    //密码模式
    _secretField.secureTextEntry = YES;

}
//通知方法
-(void)showPhoneNumber:(NSNotification *)cation{
    
    NSString * str = cation.userInfo[@"phoneNumber"];
    _IDfield.text = str;
}
-(void)creatNavgationBar{
    //状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    UIView * navBegView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, KNAV_TOOL_HEIGHT)];
    navBegView.backgroundColor = [UIColor colorWithHexString:MainColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+self.StatusBarHeight, 160, 44)];
    label.textColor = [UIColor whiteColor];
    label.center = CGPointMake(ScreenW/2.0f, 42+self.StatusBarHeight);
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:16];
    [label setText:@"账号登录"];
    
    UIButton * button= [[UIButton alloc] initWithFrame:CGRectMake(5, 20+self.StatusBarHeight, 60, 40)];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setImage:[UIImage imageNamed:@"sign_in_fanhui@2x"] forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImagePositionWithType:SSImagePositionTypeLeft spacing:6];
    //添加点击事件
    [button addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchDown];
    [navBegView addSubview:label];
    [navBegView addSubview:button];
    [self.view addSubview:navBegView];
}

-(void)goBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark---创建视图
-(void)creatUI{
    
    //创建整体的背景图
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, KNAV_TOOL_HEIGHT, ScreenW, screenH)];
    [self.view addSubview:_bgView];
    
    //设置背景颜色
    _bgView.backgroundColor = [UIColor colorWithHexString:BackColor];

    //创建背景图
    UIImageView *  HaiduiImageView=[[UIImageView alloc] initWithFrame:CGRectMake(80, 40+self.StatusBarHeight, ScreenW -160, 162 * ScreenScale)];
    [HaiduiImageView setImage:[UIImage imageNamed:@"sign_in_haidui"]];
    [_bgView addSubview:HaiduiImageView];
        
    //创建左视图

    UIButton * leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    [leftBtn setTitle:@"账户" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:4];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"sign_in_user@2x"] forState:UIControlStateNormal];
    
    UIButton * leftBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 80, 20)];
    [leftBtn2 setTitle:@"密码" forState:UIControlStateNormal];
    leftBtn2.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftBtn2 setImagePositionWithType:SSImagePositionTypeLeft spacing:4];
    [leftBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn2 setImage:[UIImage imageNamed:@"sign_in_suo@2x"] forState:UIControlStateNormal];
    //创建右视图
//    UIImageView * rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW - 50, 0 , 15, 15)];
//    rightImageView.image = [UIImage imageNamed:@"icon_urse_display_off@2x"];
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [rightBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:4];
  
    [rightBtn setImage:[UIImage imageNamed:@"icon_urse_display_off@2x"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"sign_in_yanjing_press@2x"] forState:UIControlStateSelected];
    rightBtn.selected = NO;

    //查看密码
    [rightBtn addTarget:self action:@selector(watchSecret:) forControlEvents:UIControlEventTouchDown];
    _IDfield=[[UITextField alloc] initWithFrame:CGRectMake(10,  252 * ScreenScale , ScreenW - 20, 45)];
    _IDfield.layer.cornerRadius = 25;
    [_IDfield setKeyboardType: UIKeyboardTypePhonePad];

    _IDfield.backgroundColor = [UIColor whiteColor];
    _IDfield.tag=200;
    _IDfield.delegate=self;
    
    _IDfield.leftViewMode = UITextFieldViewModeAlways;
    
    _IDfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_IDfield setPlaceholder:@"请输入手机号"];
    _IDfield.leftView = leftBtn;
    
    [_bgView addSubview:_IDfield];
    
    //密码
    _secretField = [[UITextField alloc] initWithFrame:CGRectMake(10,252 * ScreenScale + 61, ScreenW -20, 45)];
    _secretField.layer.cornerRadius = 25;
    _secretField.backgroundColor = [UIColor whiteColor];
    _secretField.leftViewMode = UITextFieldViewModeAlways;
    _secretField.rightViewMode = UITextFieldViewModeAlways;
    _secretField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_secretField setPlaceholder:@"请输入密码"];

    _secretField.leftView = leftBtn2;
    _secretField.rightView = rightBtn;

    _secretField.delegate=self;
    _secretField.tag=300;
    [_bgView addSubview:_secretField];
    
    //创建登录按钮
    UIButton * landBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 252  * ScreenScale + 150, ScreenW - 20, 45)];
    landBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
    [landBtn setTitle:@"登录" forState:UIControlStateNormal];
    [landBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    landBtn.layer.cornerRadius = 20;
    //登录事件
    [landBtn addTarget:self action:@selector(landAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:landBtn];
    
    //注册
    UIButton * registBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW -120, screenH - 60 -64-self.TabbarHeight, 100 , 30)];
    [registBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    registBtn.titleLabel.textAlignment = 1;
    [registBtn addTarget:self action:@selector(jumpRegistVC) forControlEvents:UIControlEventTouchUpInside];
    [registBtn setTitle:@"前往注册" forState:UIControlStateNormal];
    [_bgView addSubview:registBtn];
    
   //忘记密码
    UIButton * forgetBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, screenH - 60 -64-self.TabbarHeight, 100, 30)];
    forgetBtn.titleLabel.textAlignment = 1;
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //添加点击事件
    [forgetBtn addTarget:self action:@selector(forgetAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:forgetBtn];
  }

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.4 animations:^{
      
      _bgView.frame  = CGRectMake(0, -60 , ScreenW, screenH);
    }];

}
-(void)watchSecret:(UIButton *)sender{
    //密码模式
    if (sender.selected == YES) {
        _secretField.secureTextEntry = YES;
        sender.selected = NO;
    }else{
        _secretField.secureTextEntry = NO;
        sender.selected = YES;
    }

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [UIView animateWithDuration:0.4 animations:^{
        
        _bgView.frame  = CGRectMake(0, KNAV_TOOL_HEIGHT , ScreenW, screenH);
    }];
    
    [textField resignFirstResponder];
    return YES;
}
//收回键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.4 animations:^{
        
        _bgView.frame  = CGRectMake(0, KNAV_TOOL_HEIGHT , ScreenW, screenH);
    }];
    [self.view endEditing:YES];
}


#pragma mark--协议代理方法
-(void)showDataDelegate:(NSString *)data secret:(NSString *)data1{
    _IDfield.text= data;
    _secretField.text= data1;
}
#pragma mark -- 忘记密码
-(void)forgetAction{
    
   ForgetScretViewController * forgetVC = [[ ForgetScretViewController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}
#pragma mark--登陆按扭点击事件
-(void)landAction{
 
    [self land];
    
}
#pragma mark ------去登录
-(void)land{
    
    __weak typeof(self)weakself = self;
    
    
    if (_IDfield.text.length == 11 && _secretField.text.length >= 6) {
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        
        [SVProgressHUD showWithStatus:@"登录中..."];
        
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        param[@"userName"] = _IDfield.text;
        param[@"password"] = _secretField.text;
[weakself.httpManager POST:landUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSString * str = responseObject[@"isSucc"];
    NSInteger i = [str intValue];
    
    if (i == 1) {
        
        NSString * username = _IDfield.text;
        NSString * userSecret = _secretField.text;
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] setObject:userSecret forKey:@"userSecret"];
        NSString * str = responseObject[@"result"][@"hasReceiveAddress"];
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"hasAddress"];
        
        
        NSDictionary * dic = responseObject[@"result"][@"user"];
        
        [User defalutManager].shopcart = [dic[@"ig_count"] integerValue];
        [User defalutManager].userName = dic[@"userName"];
        //
        [User defalutManager].integral  = [dic[@"integral"] integerValue];
        [User defalutManager].preDeposit = [dic[@"preDeposit"] floatValue];
        
        [User defalutManager].balance = [dic[@"balance"] floatValue];
        //红包
        [User defalutManager].redPacket = [dic[@"redPacket"] integerValue];
        [User defalutManager].photo = dic[@"photo"];
        [User defalutManager].id = dic[@"id"];
        
         [User defalutManager].lineShopCart = [dic[@"shopcart"] integerValue];
        NSString * birthday = dic[@"birthday"];
        //是否设置了生日
        if( birthday != nil)
        {
        [User defalutManager].birthday = [dic[@"birthday"] longLongValue];
            
        };
        
        [User defalutManager].sex = [dic[@"sex"] integerValue];
        
        //个人头像本地保存
        NSArray * pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * documentPath = pathArray[0];
        NSString * imageDocPath = [NSString stringWithFormat:@"%@/ImageFile",documentPath];
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSString * imagePath = [NSString stringWithFormat:@"%@/image.png",imageDocPath];
        
        NSData * imageData = [NSData dataWithContentsOfURL:[NSURL  URLWithString:[User defalutManager].photo]];
        
        UIImage * currentImage = [UIImage imageWithData:imageData];
        [UIImageJPEGRepresentation(currentImage, 0.5) writeToFile:imagePath  atomically:YES];
        
        [[NSFileManager defaultManager] createFileAtPath:imagePath contents:imageData attributes:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"landOK" object:nil];
        
        //发送友盟的token给服务器
        [self registUMOK];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            [SVProgressHUD dismissWithDelay:1];
            
        });
        
    }else{
        
        [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        [SVProgressHUD dismissWithDelay:2];
        
    }

} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
     [SVProgressHUD showErrorWithStatus:@"网路错误"];
    
}];
  
        
    }else if(_secretField.text.length< 6){
        
      
        [self showStaus:@"密码不能少于6位"];
        
    }else if (_IDfield.text.length != 11){
        
        [self showStaus:@"手机号码有误"];
    }

}
//跳转到注册界面
-(void)jumpRegistVC{
    
    HDRegisterController * registVC = [[HDRegisterController alloc] init];
  //  __weak typeof(self)weakself = self;

    registVC.block = ^(NSString * str){
        
        _IDfield.text = str;
    };
    
  [self.navigationController pushViewController:registVC animated:YES];
}

- (void)returnText:(ReturnTextBlock)block{
     self.returnTexBlock = block;
}


//判断是否是电话号码
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
#pragma mark -----向服务器注册token
-(void)registUMOK{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        param[@"deviceToken"] =[[NSUserDefaults standardUserDefaults] objectForKey:@"UMToken"];
        
        param[@"alias"] = [User defalutManager].id;
        
        param[@"tag"] = @"ios";
        [self POST:uploadUPushInformationUrl parameters:param success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
    }
    
}
#pragma mark --移除观察
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
