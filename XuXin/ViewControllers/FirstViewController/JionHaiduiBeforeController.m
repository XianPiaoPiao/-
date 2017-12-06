//
//  JionHaiduiBeforeController.m
//  XuXin
//
//  Created by xuxin on 16/12/5.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "JionHaiduiBeforeController.h"
#import "JoinRegisterController.h"
#import "PlayerButton.h"
#import <AVFoundation/AVFoundation.h>


@interface JionHaiduiBeforeController ()<UIWebViewDelegate>
@property (nonatomic ,strong)UIWebView * webView;
@end

@implementation JionHaiduiBeforeController{
    
    AVPlayer * _player;

}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
   self.navigationController.navigationBarHidden = YES;
 
    [MTA trackPageViewBegin:@"JionHaiduiBeforeController"];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [MTA trackPageViewEnd:@"JionHaiduiBeforeController"];
    
}

- (void)viewDidLoad {
    //

    [super viewDidLoad];
    
    [self creatNavgationBar];
    
    [self creatUI];
    
    [self creatPlaer];

    //
  //  self.view.backgroundColor = [UIColor whiteColor];
    
   // self.mainScrollView.contentInset =  UIEdgeInsetsMake(0, 0, 170 * ScreenScale, 0);
    
  //  [self creatNavgationBar];
    
  //  [self settingUI];
    

}

-(void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatUI{
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, KNAV_TOOL_HEIGHT, ScreenW, screenH -64-self.StatusBarHeight-self.TabbarHeight )];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:home_AgentHtml]]];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        [self getUserOrStore_StatusData];
        
        return NO;
    }
    return YES;
}
-(void)creatNavgationBar{
    
    [self addBarButtonItemWithTitle:@"" image:[UIImage imageNamed:@"sign_in_fanhui@2x"] target:self action:@selector(playAndStop:) isLeft:NO];
    
    UIView * navBegView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, KNAV_TOOL_HEIGHT)];
    navBegView.backgroundColor = [UIColor colorWithHexString:MainColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+self.StatusBarHeight, 160, 44)];
    label.textColor = [UIColor whiteColor];
    label.center = CGPointMake(ScreenW/2.0f, 42+self.StatusBarHeight);
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:16];
    [label setText:@"加盟前必读"];
    
    UIButton * button= [[UIButton alloc] initWithFrame:CGRectMake(5, 25+self.StatusBarHeight, 60, 40)];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setImage:[UIImage imageNamed:@"sign_in_fanhui@2x"] forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImagePositionWithType:SSImagePositionTypeLeft spacing:3];
    //添加点击事件
    [button addTarget:self action:@selector(returnToMianVC) forControlEvents:UIControlEventTouchDown];
    [navBegView addSubview:label];
    [navBegView addSubview:button];
    [self.view addSubview:navBegView];

}
-(void)returnToMianVC{
    
    [SVProgressHUD dismiss];

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)settingUI{
    
    self.mainContentLabel.layer.masksToBounds = YES;
    self.mainContentLabel.layer.cornerRadius = 6;
    self.mainContentLabel.backgroundColor = [UIColor colorWithHexString:MainColor];
  
    self.mainContentLabel.insets = UIEdgeInsetsMake(0, 10, 0, 5);//通过设置insets属性直接设置Label的内边距。
//    self.oneContentLabel.insets = UIEdgeInsetsMake(0, 10, 0, 5);
//    self.twoContentLabel.insets = UIEdgeInsetsMake(0, 10, 0, 5);
//    self.threeContentLabel.insets = UIEdgeInsetsMake(0, 10, 0, 5);
 NSString * labelText = @"       企业入驻加盟后,就等于免入股“嗨兑”,就等于员工的福利由“嗨兑”支付,就等于享受天天分红。企业加盟后，你推荐注册“嗨兑”平台的任何消费者。他们在全国各地的加盟商家消费(含衣,食,住,行,教育,医疗,购物,娱乐等),你都将获得“嗨兑“平台的天天分红,你推荐的”嗨兑”用户越多,你的分红越多,加盟后你的实体店铺将不单靠本店的营收入,“嗨兑”分红给你的收入会超过你实体店的经营收入。";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:4];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.mainContentLabel.attributedText = attributedString;
    
    [self.mainContentLabel sizeToFit];
    
    self.oneContentLabel.layer.masksToBounds = YES;
    self.oneContentLabel.layer.cornerRadius = 8;
    self.oneContentLabel.layer.borderWidth = 1;
    self.oneContentLabel.layer.borderColor = [UIColor colorWithHexString:MainColor].CGColor;
  
    NSString * labelText2 =@"      一个商家每日顾客有150人,其中有50人注册成功为“嗨兑”用户,那么一年就有:(50 X 365(天)=18250)";
      NSMutableAttributedString * attributedString2 = [[NSMutableAttributedString alloc] initWithString:labelText2];
    [paragraphStyle setLineSpacing:4];//调整行间距
    [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText2 length])];
  
    self.oneContentLabel.attributedText = attributedString2;
    [self.oneContentLabel sizeToFit];

    
    
    self.twoContentLabel.layer.masksToBounds = YES;
    self.twoContentLabel.layer.cornerRadius = 8;
    self.twoContentLabel.layer.borderWidth = 1;
    self.twoContentLabel.layer.borderColor = [UIColor colorWithHexString:MainColor].CGColor;
    NSString * labelText3 =@"      若每个消费者一年在全国各地的消费总额是2万元,那么加盟商家的分红收入就是（18250x2x（1+1）%=730万)";
    NSMutableAttributedString * attributedString3 = [[NSMutableAttributedString alloc] initWithString:labelText3];

    [paragraphStyle setLineSpacing:4];//调整行间距
    
    [attributedString3 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText3 length])];
    
    self.twoContentLabel.attributedText = attributedString3;
    [self.twoContentLabel sizeToFit];
    
    
    self.threeContentLabel.layer.masksToBounds = YES;
    self.threeContentLabel.layer.cornerRadius = 8;
    self.threeContentLabel.layer.borderWidth = 1;
    self.threeContentLabel.layer.borderColor = [UIColor colorWithHexString:MainColor].CGColor;
    NSString * labelText4 =@"      这种分红收入每月还会随着你注册会员人数的增加而增加远远超越你经营店铺的收入。";
    NSMutableAttributedString * attributedString4 = [[NSMutableAttributedString alloc] initWithString:labelText4];

    [paragraphStyle setLineSpacing:4];//调整行间距
    [attributedString4 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText4 length])];
    
    self.threeContentLabel.attributedText = attributedString4;
    [self.threeContentLabel sizeToFit];
    
    self.nextBtn.layer.cornerRadius = 12;
    self.nextBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
    [self.nextBtn addTarget:self action:@selector(jumpNextVC) forControlEvents:UIControlEventTouchDown];
    
}
-(void)jumpNextVC{
    //菊花
    [SVProgressHUD showWithStatus:@"请等待"];
    [self getUserOrStore_StatusData];
  
}

-(void)getUserOrStore_StatusData{
    
    [SVProgressHUD showWithStatus:@"请等待"];

    __weak typeof(self)weakself = self;
    [weakself.httpManager POST:getUserOrStore_StatusUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];

        NSString * storeIsOk = responseObject[@"result"][@"storeIsOk"];
        NSString * userStatus = responseObject[@"result"][@"userStatus"];
        NSString * store_status = responseObject[@"result"][@"store_status"];
        if ([storeIsOk intValue] == 1 && [userStatus intValue] == 1) {
            
            JoinRegisterController * joinRejsterVC = [[JoinRegisterController alloc] init];
            joinRejsterVC.userType = 1;
            [self.navigationController pushViewController:joinRejsterVC animated:YES];
            
        }else if ([store_status intValue] == 1){
            
            [self showStaus:@"等待审核"];
        }else if ([store_status intValue] == 2){
            
            [self showStaus:@"正常营业"];
        }else if ([store_status intValue] == 3){
            
            [self showStaus:@"违规关闭"];
            
        }else if ([store_status intValue] == -1){
            
            [self showStaus:@"审核拒绝"];
            
        }else if ([userStatus intValue] == 0){
            
            JoinRegisterController * joinRejsterVC = [[JoinRegisterController alloc] init];
            joinRejsterVC.userType = 2;
            [self.navigationController pushViewController:joinRejsterVC animated:YES];
        }
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
    }];
  
}
-(void)creatPlaer{
    
    //参数1:播放的对象
    PlayerButton * playerBtn = [[PlayerButton alloc] initWithFrame:CGRectMake(ScreenW - 40, 27, 30, 30)];
    [self.view addSubview:playerBtn];
    [playerBtn setImage:[UIImage imageNamed:@"bofanganniu1"] forState:UIControlStateNormal];
    //  [self.view addSubview:playerBtn];
    [playerBtn setImage:[UIImage imageNamed:@"bofanganniu2"] forState:UIControlStateSelected];
    [playerBtn addTarget:self action:@selector(playAndStop:) forControlEvents:UIControlEventTouchUpInside];
    playerBtn.selected = NO;
    AVPlayerItem * item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:wydlmp3Url]];
    
    _player = [[AVPlayer alloc] initWithPlayerItem:item];
    
    //    _progress = [[UISlider alloc] initWithFrame:CGRectMake(10, 74, ScreenW - 90, 20)];
    //    _progress.tintColor = [UIColor colorWithHexString:MainColor];
    //    [self.view addSubview:_progress];
    //4.监测播放进度
    //参数2：block执行队列
    //参数3：每隔0.1秒去调用的block
    __weak AVPlayer * tplayer = _player;
    //  __weak UISlider * tslider = _progress;
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 10) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //总的帧数
        CMTime totalTime = tplayer.currentItem.duration;
        //总的时间
    //    float total = totalTime.value * 1.0f/totalTime.timescale;
    //    float curret = time.value * 1.0f/time.timescale;
        
        //  tslider.value =curret / total;
    }];
    //设置音量
    _player.volume = 0.5;
    //设置播放速度
    //使用消息中心去监测播放结束的时候(这个消息不需要程序员来发送)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPlay) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    
    
}
//播放按钮
-(void)playAndStop:(UIButton *)sender{
    
    if (sender.selected == YES) {
        [_player pause];
        
        sender.selected = NO;
    }else{
        
        [_player play];
        
        sender.selected = YES;
    }
    
}

-(void)endPlay{
    
    AVPlayerItem * item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:wydlmp3Url]];
    [_player replaceCurrentItemWithPlayerItem:item];
    [_player play];
    
}
//改变播放进度
- (void)sliderChange:(UISlider *)sender {
    //value,媒体文件的总的帧数
    //timeScale 每一秒播放的帧数
    //获取当前播放源总的帧数
    AVPlayerItem * current = _player.currentItem;
    //获取总的帧数
    CMTime timeDuration = current.duration;
    CMTimeValue total = timeDuration.value;
    CMTimeScale speed = timeDuration.timescale;
    //设置进度
    [_player seekToTime:CMTimeMake(total * sender.value, speed)];
}

@end
