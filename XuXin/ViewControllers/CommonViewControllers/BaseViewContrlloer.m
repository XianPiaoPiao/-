//
//  BaseViewContrlloer.m
//  XuXin
//
//  Created by xuxin on 16/8/10.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"
#import "LandingViewController.h"
#import "EaseLoadingView.h"
#import "POPAnimation.h"
#import "MBProgressHUD+NJ.h"

@interface BaseViewContrlloer ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator ;


@end

@implementation BaseViewContrlloer{
    
    UIView * _indicatorBgView;
    UIPercentDrivenInteractiveTransition * _interactiveTransition;
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [MTA trackPageViewBegin:self.description];
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [MTA trackPageViewEnd:self.description];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
 //   id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    
    // handleNavigationTransition:为系统私有API,即系统自带侧滑手势的回调方法，我们在自己的手势上直接用它的回调方法
 //   UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    
 //   panGesture.delegate = self; // 设置手势代理，拦截手势触发
 //  [self.view addGestureRecognizer:panGesture];
    
 //  一定要禁止系统自带的滑动手势
 //  self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    
    [self customNavigationItem];
    // Do any additional setup after loading the view.
}


-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if (self.navigationController.childViewControllers.count == 1) {
        
        return NO;
    }
    
    return YES;
}

- (NSInteger)StatusBarHeight{
    NSInteger height = 0;
    if (kDevice_Is_iPhoneX) {
        height = 20;
    } else{
        height = 0;
    }
    return height;
}

- (NSInteger)TabbarHeight{
    NSInteger height = 0;
    if (kDevice_Is_iPhoneX) {
        height = 34;
    } else {
        height = 0;
    }
    return height;
}

-(AFHTTPSessionManager *)httpManager{
    if (!_httpManager) {
        
        _httpManager = [AFHTTPSessionManager manager];
        //设置序列化,将JSON数据转化为字典或者数组
       
        AFJSONResponseSerializer *response  = [AFJSONResponseSerializer serializer];
        
        //这个参数 removesKeysWithNullValues 可以将null的值删除，那么就Value为nil了
        response.removesKeysWithNullValues = YES;
        
        _httpManager.responseSerializer  = response;
        //在序列化器中追加一个类型，text、html这个类型不支持的，text、json，apllication，json
        _httpManager.responseSerializer.acceptableContentTypes = [_httpManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        _httpManager.requestSerializer.timeoutInterval = 10;
        
        
        AFHTTPRequestSerializer *afHTTPRequestSerializer = [AFHTTPRequestSerializer serializer];
    
        _httpManager.requestSerializer = afHTTPRequestSerializer;
        
//        //https 配置证书
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:
//                                 @"wt_https_ssl" ofType:@"cer"];
//        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"songchunmin" ofType:@"cer"];//证书的路径
//       NSData *certData = [NSData dataWithContentsOfFile:cerPath];
//        
        // AFSSLPinningModeCertificate 使用证书验证模式
        AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];//AFSSLPinningModeNone
        
//        // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//        // 如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
//        
//        /*
//         validatesDomainName 是否需要验证域名，默认为YES；
//         假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
//         置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//         如置为NO，建议自己添加对应域名的校验逻辑。
//         
//         */
        securityPolicy.validatesDomainName = NO;
//        
//       securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
//        
        [_httpManager setSecurityPolicy:securityPolicy];
      
////
    }
//    
  return _httpManager;

}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler{
    NSLog(@"didReceiveChallenge");
    //    if([challenge.protectionSpace.host isEqualToString:@"api.lz517.me"] /*check if this is host you trust: */ ){
    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
    //    }
}

- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure
{
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]; // 开启状态栏动画
    
    [self.httpManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];

        if (success)
        {
            
            success(responseObject);
            
            NSInteger code = [responseObject[@"code"] integerValue];

            NSString * str = responseObject[@"isSucc"];
            if ([str integerValue] != 1) {

            if (code == 7009) {
       
                [self showStaus:@"登录已过期,请重新登录"];

                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                    
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [self goLanding];

                });

                
            }else if (code == 7230){
                
                
            }else if (code == 7030){
                
            }
            else{
                    
                [self showStaus:responseObject[@"msg"]];
                
            }
        }
    }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
        
        [SVProgressHUD dismiss];
        
        [self showStaus:@"网络错误,请检查你的网络"];
        
        if (failure)
        {
            failure(error);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画
    }];
}

-(void)addNavgationTitle:(NSString *)title{
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = 1;
    titleLabel.text = title;
    
    //设置导航的titleView
    self.navigationItem.titleView = titleLabel;
    
    
}
-(void)addBarButtonItemWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)selector isLeft:(BOOL)isLeft{
    
    UIButton * barButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
  //让按钮所有内容水平向左
  //  barButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    barButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [barButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    barButton.selected = NO;
    //设置按钮的标题
    [barButton setTitle:title forState:UIControlStateNormal];
    [barButton setImagePositionWithType:SSImagePositionTypeLeft spacing:-4];
    
    //设置按钮背景
    [barButton setImage:image forState:UIControlStateNormal];
    barButton.tintColor = [UIColor blackColor];
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    insets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 20.0f);
    [barButton setImageEdgeInsets:insets];//Offset
    
    //设置target -action
    [barButton addTarget:target action:selector forControlEvents:UIControlEventTouchDown];
    //创建uibarButtonItem
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    //判断是否在左侧
    if (isLeft) {
        
        self.navigationItem.leftBarButtonItem = barButtonItem;
        
    } else{
        
        self.navigationItem.rightBarButtonItem = barButtonItem;
        [barButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
}
-(void)addMainBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)selector isLeft:(BOOL)isLeft{
    
    UIImage * image = [UIImage imageNamed:@"buttonbar_action"];
    [self addBarButtonItemWithTitle:title image:image target:target action:selector isLeft:isLeft];
}
-(void)addBackBarButtonItem{
    
    [self addBarButtonItemWithTitle:@"返回" image:[UIImage imageNamed:@"fanhui@3x"] target:self action:@selector(backAction) isLeft:YES];
    
}
-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//定制navgationItem
//约定大于配置，由子类重写
-(void)customNavigationItem{
    
  //  [self addBackBarButtonItem];
    
}

-(void)showStaus:(NSString *)str{
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    // 设置显示文本信息
    hud.label.text = str;
    
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.textColor = [UIColor whiteColor];
    //设置小矩形背景颜色
    hud.bezelView.color = [UIColor blackColor];
    
    
    // 2秒钟之后隐藏HUD
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [hud hideAnimated:YES afterDelay:2];
        
    });
}


-(void)creatIndortor{
    
    _indicatorBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH)];
    _indicatorBgView.tag = buttonTag;
    _indicatorBgView.backgroundColor = [UIColor blackColor];

    _indicatorBgView.alpha = 0.7;
     self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.activityIndicator.backgroundColor = [UIColor blackColor];
    
     self.activityIndicator.center = CGPointMake(ScreenW /2.0f, (screenH - 100)/2.0f);
    
     [_indicatorBgView addSubview:self.activityIndicator];
     [self.view addSubview:_indicatorBgView];
    
     self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;

     [self.activityIndicator startAnimating];



}
-(void)goLanding{
    
    LandingViewController * landVC = [[LandingViewController alloc] init];
    [self.navigationController pushViewController:landVC animated:YES];
}

- (void)timerStop
{
    [_indicatorBgView removeFromSuperview];
    [self.activityIndicator stopAnimating];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

@end
