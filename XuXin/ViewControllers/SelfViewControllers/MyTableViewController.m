//
//  MyTableViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/24.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MyTableViewController.h"
#import "MessageViewController.h"
#import "LandingViewController.h"
#import "CollectionFoldBaseViewController.h"
#import "ReconmendFriendsViewController.h"
#import "MyOrderBaseViewController.h"
#import "MyWalletViewController.h"
#import "MyRedWalletViewController.h"
#import "MyBusinessViewController.h"
#import "VoucherViewController0.h"
#import "MySettingTableViewController.h"
#import "HDshopCarBaseController.h"
#import "MyCollcetionBaseController.h"
#import "RecomodRankBaseViewController.h"
#import "RecommondStoreBaseController.h"
#import "UserCommentController.h"
#import "UIButton+WebCache.h"
@interface MyTableViewController ()
@property (weak, nonatomic) IBOutlet UIButton *HeaderButton;
@property (weak, nonatomic) IBOutlet UIButton *supendPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UILabel *messageBageLabel;

@property (weak, nonatomic) IBOutlet UIButton *queueBtn;
@property (weak, nonatomic) IBOutlet UILabel *supendChargeLabel;
@property (weak, nonatomic) IBOutlet UILabel *supendBankLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (nonatomic ,strong)NSString * imagePath;

@property (nonatomic ,strong)AFHTTPSessionManager * httpManager;
@end

@implementation MyTableViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //设置个人中心图片
    self.HeaderButton.layer.masksToBounds = YES;
    self.HeaderButton.layer.cornerRadius = 30;
    self.supendPayBtn.layer.cornerRadius = 3;
    self.queueBtn.layer.cornerRadius = 3;
    
    self.navigationController.navigationBarHidden = YES;
//    [self setStatusBarBackgroundColor:[UIColor colorWithHexString:MainColor]];
    //更新数据
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        
        [self updateUserData];
        
        [self updateHeaderView];
        
    }else{
        
        [self updateUserUI];
        
    }
    
    [MTA trackPageViewBegin:@"MyTableViewController"];
    
}
////设置状态栏颜色
//- (void)setStatusBarBackgroundColor:(UIColor *)color {
//
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//        statusBar.backgroundColor = color;
//    }
//}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"MyTableViewController"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.tableView.showsVerticalScrollIndicator= NO;
    
//    self.preferredStatusBarStyle

    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    //注册通知
    
    //退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLandNoState) name:@"backToLand" object:nil];
    //登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLandNoState) name:@"landOK" object:nil];


    [self updateHeaderView];

}

-(BOOL)fd_prefersNavigationBarHidden {
    
    return YES;
}
#pragma mark --- 更新头像
-(void)updateHeaderView{
    
    //jiaobiao
    [User defalutManager].bage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"badge"] integerValue];

    if ([User defalutManager].bage > 0) {
        
        
        [_messageBtn setImage:[UIImage imageNamed:@"Red-Icon-1"] forState:UIControlStateNormal];
        
    }else{
     
       [_messageBtn setImage:[UIImage imageNamed:@"my_icon_news@3x"] forState:UIControlStateNormal];
    }
 
    
    //与设置图片同步
    
    NSString * fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"ImageFile/image.png"];
//    NSLog(@"%@",fullPath);
    UIImage * image =[UIImage imageWithContentsOfFile:fullPath];
 
 
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        
      if (image ==nil) {
                
         [self.HeaderButton setBackgroundImage:[UIImage imageNamed:@"the_charts_tx"] forState:UIControlStateNormal];
          
        }else{
                
        [self.HeaderButton setBackgroundImage:image forState:UIControlStateNormal];
        }

     
    }else{
        
        //设置默认图片
     [self.HeaderButton setBackgroundImage:[UIImage imageNamed:@"the_charts_tx"] forState:UIControlStateNormal];
      
    }
    

    
}
#pragma mark ---更新界面
-(void)updateUserUI{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        //余额
        self.supendChargeLabel.text = [NSString stringWithFormat:@"%.2f",[User defalutManager].balance];
        //预存款
        self.supendBankLabel.text =[NSString stringWithFormat:@"%.2f",[User defalutManager].preDeposit];
        self.pointLabel.text = [NSString stringWithFormat:@"%ld",[User defalutManager].integral];
        
        self.userNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        
    } else{
        
        self.supendChargeLabel.text = [NSString stringWithFormat:@"0.00"];
        self.supendBankLabel.text =[NSString stringWithFormat:@"0"];
        self.pointLabel.text = [NSString stringWithFormat:@"0"];
        self.userNameLabel.text = @"点击登录";
        self.userNameLabel.font = [UIFont systemFontOfSize:15];

}
   
}
#pragma mark --个人数据更新
-(void)updateUserData{
    
    __weak typeof(self)weakself = self;
    
    [weakself.httpManager POST:getUserInfoUrl  parameters:nil  progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            NSMutableDictionary * dic = responseObject[@"result"];
            [User defalutManager].preDeposit = [dic[@"shopcoin"] floatValue];
            [User defalutManager].balance = [dic[@"availableBalance"] floatValue];
            [User defalutManager].integral = [dic[@"integral"] integerValue];
            [User defalutManager].ucard = dic[@"ucard"];
        }
        
           dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself updateUserUI];
               
          });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    

}
#pragma mark  ----通知方法
-(void)showLandNoState{
    
    //更新界面和数据
    [self updateUserUI];
    //更新头像
    [self updateHeaderView];
    
}
#pragma mark ---购物车
- (IBAction)ShopAction:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        HDshopCarBaseController * shopVC = [[HDshopCarBaseController alloc] init];

        [self.navigationController pushViewController:shopVC animated:YES];

    } else{
        
        LandingViewController * landVC = [[LandingViewController alloc] init];
        [self.navigationController pushViewController:landVC animated:YES];
    }
   
}
#pragma  mark ----消息中心
- (IBAction)MessageAction:(id)sender {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        
    MessageViewController * messageVC = [[MessageViewController alloc] init];
   [self.navigationController pushViewController:messageVC animated:YES];
        
    } else{
        
        LandingViewController * landVC = [[LandingViewController alloc] init];
        [self.navigationController pushViewController:landVC animated:YES];
    }
}
#pragma mark ----我的设置
- (IBAction)SettingAction:(id)sender {
   
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        MySettingTableViewController * settingVC = [storyBoard instantiateViewControllerWithIdentifier:@"MySettingTableViewController"];
        __weak typeof(self)weakSelf = self;
        settingVC.block = ^(NSString * cateId){
            
            weakSelf.imagePath = cateId;
            //加载数据
            UIImage * image =[UIImage imageWithContentsOfFile:weakSelf.imagePath];
            if (image ==nil) {
                
//                [self.HeaderButton setBackgroundImage:image forState:UIControlStateNormal];
                [self.HeaderButton setBackgroundImage:[UIImage imageNamed:@"the_charts_tx"] forState:UIControlStateNormal];
                
            }else{
                
                [self.HeaderButton setBackgroundImage:image forState:UIControlStateNormal];
            }
            
        };
        
    [self.navigationController pushViewController:settingVC animated:YES];
        
    } else{
        LandingViewController * landVC = [[LandingViewController alloc] init];
        [self.navigationController pushViewController:landVC animated:YES];
    }
   
}
#pragma mark ---点击图片登录
- (IBAction)settingLandAction:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
      //点击头像跳转页面
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        MySettingTableViewController * settingVC = [storyBoard instantiateViewControllerWithIdentifier:@"MySettingTableViewController"];
        __weak typeof(self)weakSelf = self;
        settingVC.block = ^(NSString * cateId){
            weakSelf.imagePath = cateId;
            //加载数据
            UIImage * image =[UIImage imageWithContentsOfFile:weakSelf.imagePath];
            if (image ==nil) {
                [self.HeaderButton setBackgroundImage:image forState:UIControlStateNormal];
                
            }else{
                [self.HeaderButton setBackgroundImage:image forState:UIControlStateNormal];
            }
            
        };
        
        [self.navigationController pushViewController:settingVC animated:YES];
        

    } else{
        LandingViewController * landVC = [[LandingViewController alloc] init];
        [self.navigationController pushViewController:landVC animated:YES];
    }

}
#pragma mark -----页面跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        //推荐朋友
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
            ReconmendFriendsViewController * shopVC = [[ReconmendFriendsViewController alloc] init];

            
            [self.navigationController pushViewController:shopVC animated:YES];
        } else{
            LandingViewController * landVC = [[LandingViewController alloc] init];
            [self.navigationController pushViewController:landVC animated:YES];
        }
        
    }
    if (indexPath.row == 3) {
        //推荐商家
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
            RecommondStoreBaseController * rankBaseVC = [[RecommondStoreBaseController alloc] init];
     
            [self.navigationController pushViewController:rankBaseVC animated:YES];
        } else{
            LandingViewController * landVC = [[LandingViewController alloc] init];
            [self.navigationController pushViewController:landVC animated:YES];
        }
        
    }
    if (indexPath.row == 5) {
        //我的订单
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
            MyOrderBaseViewController * orderVC = [[MyOrderBaseViewController alloc] init];
            [self.navigationController pushViewController:orderVC animated:YES];

        } else{
            LandingViewController * landVC = [[LandingViewController alloc] init];
            [self.navigationController pushViewController:landVC animated:YES];
        }
    }
    if (indexPath.row == 6) {
        //我的红包
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
            MyRedWalletViewController * myRedWalletVC = [[MyRedWalletViewController alloc] init];
            
            [self.navigationController pushViewController:myRedWalletVC animated:YES];
            
            
        } else{
            LandingViewController * landVC = [[LandingViewController alloc] init];
            [self.navigationController pushViewController:landVC animated:YES];
        }
       
        
    }
    if (indexPath.row == 7) {
    
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
            //我的钱包
            MyWalletViewController * myWalletVC = [[MyWalletViewController alloc] init];
        
            [self.navigationController pushViewController:myWalletVC animated:YES];
        } else{
        
            LandingViewController * landVC = [[LandingViewController alloc] init];
            [self.navigationController pushViewController:landVC animated:YES];
        }
    
    } else if (indexPath.row == 8){
        
//        MyBusinessViewController * myBusinessVC = [[MyBusinessViewController alloc] init];
//        
//        [self.navigationController pushViewController:myBusinessVC animated:YES];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
            //我的名片
            MyBusinessViewController * myBusinessVC = [[MyBusinessViewController alloc] init];
            
            [self.navigationController pushViewController:myBusinessVC animated:YES];
        } else{
            
            LandingViewController * landVC = [[LandingViewController alloc] init];
            [self.navigationController pushViewController:landVC animated:YES];
        }
    }
    
      else if (indexPath.row == 9){//兑换券
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
            
            VoucherViewController0 * vocherVC = [[VoucherViewController0 alloc] init];

            [self.navigationController pushViewController:vocherVC animated:YES];
            
            
        } else{
            
            LandingViewController * landVC = [[LandingViewController alloc] init];
            [self.navigationController pushViewController:landVC animated:YES];
        }
       
        //我的收藏
    }
    if (indexPath.row == 10) {
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
            
            MyCollcetionBaseController * baseVC = [[MyCollcetionBaseController alloc] init];
            
            [self.navigationController pushViewController:baseVC animated:YES];
            
            
        } else{
            
            LandingViewController * landVC = [[LandingViewController alloc] init];
            [self.navigationController pushViewController:landVC animated:YES];
        }
 
    }else if (indexPath.row == 12){
      
        
        UIWebView * webVIew = [[UIWebView alloc] init];
        NSString * phoneNumber = @"4000239719";
        
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]];
        [webVIew loadRequest:[NSURLRequest requestWithURL:url]];
        [self.view addSubview:webVIew];
        
    }
    else if(indexPath.row == 13){
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
            
            UserCommentController * userCommentVC = [[UserCommentController alloc] init];
            [self.navigationController pushViewController:userCommentVC animated:YES];
        }else{
            
            LandingViewController * landVC = [[LandingViewController alloc] init];
            [self.navigationController pushViewController:landVC animated:YES];
        }
 
        
    }
    
}

-(AFHTTPSessionManager *)httpManager{
    if (!_httpManager) {
        
        _httpManager = [AFHTTPSessionManager manager];
        //设置序列化,将JSON数据转化为字典或者数组
        _httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        //在序列化器中追加一个类型，text、html这个类型不支持的，text、json，apllication，json
        _httpManager.responseSerializer.acceptableContentTypes = [_httpManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        _httpManager.requestSerializer.timeoutInterval =15;
        
        // AFSSLPinningModeCertificate 使用证书验证模式
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
       
        securityPolicy.allowInvalidCertificates = YES;
        //域名验证
        [securityPolicy setValidatesDomainName:NO];

        [_httpManager setSecurityPolicy:securityPolicy];
    }
    
    return _httpManager;
    
}

//移除观察者
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
