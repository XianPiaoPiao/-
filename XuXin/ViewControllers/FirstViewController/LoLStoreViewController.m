//
//  LoLStoreViewController.m
//  XuXin
//
//  Created by xuxin on 16/11/9.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "LoLStoreViewController.h"
#import "PlayerButton.h"
#import <AVFoundation/AVFoundation.h>
@interface LoLStoreViewController ()
@property (nonatomic ,strong)UIWebView * LOLStoreWebView;
@property (strong, nonatomic) UISlider *progress;
@end

@implementation LoLStoreViewController{
    AVPlayer * _player;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MTA trackPageViewBegin:@"LoLStoreViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"LoLStoreViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    [self creatNavgationBar];
    
    [self creatUI];
    
}

-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"我要加盟"];
    
    [self addBackBarButtonItem];
}

-(void)creatUI{
    
    //参数1:播放的对象
    PlayerButton * playerBtn = [[PlayerButton alloc] initWithFrame:CGRectMake(ScreenW - 60, 70, 30, 30)];
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
    __weak UISlider * tslider = _progress;
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 10) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //总的帧数
        CMTime totalTime = tplayer.currentItem.duration;
        //总的时间
        float total = totalTime.value * 1.0f/totalTime.timescale;
        float curret = time.value * 1.0f/time.timescale;
        
        tslider.value =curret / total;
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
