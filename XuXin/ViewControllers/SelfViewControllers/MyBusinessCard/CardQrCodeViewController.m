//
//  CardQrCodeViewController.m
//  XuXin
//
//  Created by xian on 2017/9/29.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "CardQrCodeViewController.h"

@interface CardQrCodeViewController ()

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *qrcodeImgView;

@end

@implementation CardQrCodeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    
    [self createUI];
    
}
- (void)createNavBar{
    UIView * navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, KNAV_TOOL_HEIGHT)];
    [self.view addSubview:navBgView];
    navBgView.backgroundColor = [UIColor colorWithHexString:MainColor];
    self.navigationController.navigationBarHidden = YES;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+self.StatusBarHeight, 160, 44)];
    label.textColor = [UIColor whiteColor];
    label.center = CGPointMake(ScreenW/2.0f, 42);
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:16];
    [label setText:@"我的二维码"];
    [navBgView addSubview:label];
    
    UIButton * returnButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 27+self.StatusBarHeight, 60, 30)];
    [returnButton setImage:[UIImage imageNamed:@"sign_in_fanhui@3x"] forState:UIControlStateNormal];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    [returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [returnButton setImagePositionWithType:SSImagePositionTypeLeft spacing:3];
    [returnButton addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchDown];
    [navBgView addSubview:returnButton];
}

- (void)returnAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI{
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:MainColor]];
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(10, 84, ScreenW-20, screenH-124)];
    bgview.backgroundColor = [UIColor whiteColor];
    bgview.layer.cornerRadius = 4;
    bgview.layer.masksToBounds = YES;
    [self.view addSubview:bgview];
    
    UIImageView *headImgView = [UIImageView new];
    [headImgView setImage:[UIImage imageNamed:@"ewm_tx"]];
    headImgView.layer.cornerRadius = 25;
    headImgView.layer.masksToBounds = YES;
    [bgview addSubview:headImgView];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:24];
    _nameLabel.text = _userName;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor colorWithHexString:WordColor];
    [bgview addSubview:_nameLabel];
    
    _qrcodeImgView = [UIImageView new];
    [_qrcodeImgView sd_setImageWithURL:[NSURL URLWithString:_qrcodePath] placeholderImage:nil];
    [bgview addSubview:_qrcodeImgView];
    
    UILabel *lable = [UILabel new];
    lable.text = @"嗨兑扫一扫，快速保存名片";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor colorWithHexString:WordColor];
    lable.font = [UIFont systemFontOfSize:15];
    [bgview addSubview:lable];
    
    
    [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgview.mas_top).offset(64);
        make.centerX.equalTo(bgview.mas_centerX);
        make.size.sizeOffset(CGSizeMake(50, 50));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImgView.mas_bottom).offset(28);
        make.centerX.equalTo(bgview.mas_centerX);
        make.size.sizeOffset(CGSizeMake(ScreenW-100, 30));
    }];
    
    [_qrcodeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(45);
        make.centerX.equalTo(bgview.mas_centerX);
        make.size.sizeOffset(CGSizeMake(152, 152));
    }];
    
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_qrcodeImgView.mas_bottom).offset(30);
        make.centerX.equalTo(bgview.mas_centerX);
        make.size.sizeOffset(CGSizeMake(250, 30));
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
