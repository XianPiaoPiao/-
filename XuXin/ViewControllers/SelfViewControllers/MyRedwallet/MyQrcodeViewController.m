//
//  MyQrcodeViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/28.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MyQrcodeViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
@interface MyQrcodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;


@property (weak, nonatomic) IBOutlet UILabel *userName;


@end

@implementation MyQrcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatNavgationBar];
    
  //  [self settingIconImage];
    
    [self firstLoad];
    

    //
    self.userName.text =  [User defalutManager].userName;
    
}
//与设置图片同步
-(void)settingIconImage{
    
    
    NSString * fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"ImageFile/image.png"];
    UIImage * image =[UIImage imageWithContentsOfFile:fullPath];


if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
    
    if (image ==nil) {
        
        [self.userImage setImage:[UIImage imageNamed:@"the_charts_tx@2x"]];
        
    }else{
        
        [self.userImage setImage:image];
    }
    
    
}else{
    
    //设置默认图片
    [self.userImage setImage:[UIImage imageNamed:@"moren_touxiang@3x"]];
    
}
}
-(void)firstLoad{
    

    NSDictionary * dic =  [HaiduiArchiverTools unarchiverObjectByKey:@"myErocodeCache" WithPath:@"myErocode.plist"];
    
    if (dic) {
        
        [_myErcodeImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"result"][@"qrcode"]] placeholderImage:nil];//[UIImage imageNamed:@""]
        
        [_userImage sd_setImageWithURL:[NSURL URLWithString:dic[@"result"][@"user_ico"]] placeholderImage:[UIImage imageNamed:@"the_charts_tx@2x"]];
        
    }
    
 
        [self requestData];

}
-(void)creatNavgationBar{
    
    _userImage.layer.masksToBounds = YES;
    _userImage.layer.cornerRadius = 40;
    
    [self addNavgationTitle:@"我的二维码"];
    [self addBackBarButtonItem];
    
   // [self addBarButtonItemWithTitle:@"" image:[UIImage imageNamed:@"s03@2x"] target:self action:@selector(shareOthers) isLeft:NO];
    [self addBarButtonItemWithTitle:@"" image:[UIImage imageNamed:@"s03@2x"] target:self action:@selector(shareOthers) isLeft:NO];
    //
    UIView * seperateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
    seperateView.backgroundColor = [UIColor colorWithHexString:BackColor];
    [self.view addSubview:seperateView];
}
-(void)shareOthers{
    
    //分享文字
    NSString * shareText = [NSString stringWithFormat:@"我的二维码"];
    
    // 显示分享界面
    
    //分享图片
    UIImage * shareImage = _myErcodeImageView.image;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMSocialAppKey                                      shareText:shareText shareImage:shareImage shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQQ,UMShareToWechatTimeline, UMShareToTencent,UMShareToWechatSession, nil] delegate:nil];
    

}
-(void)requestData{
    
    __weak typeof(self)weakself = self;
    
    [weakself POST:myQrcodeUrl parameters:nil success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            //归档
           [HaiduiArchiverTools archiverObject:responseObject ByKey:@"myErocodeCache" WithPath:@"myErocode.plist"];
            
            [_myErcodeImageView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"result"][@"qrcode"]] placeholderImage:nil];//[UIImage imageNamed:@""]
            
            [_userImage sd_setImageWithURL:[NSURL URLWithString:responseObject[@"result"][@"user_ico"]] placeholderImage:[UIImage imageNamed:@"the_charts_tx@2x"]];
        }
    } failure:^(NSError *error) {
        

        
    }];
   

    
}
-(void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
