//
//  HotelInquireViewController.m
//  TableDemo
//
//  Created by 沈鑫 on 2018/2/2.
//  Copyright © 2018年 沈鑫. All rights reserved.
//

#import "HotelInquireViewController.h"
#import "HotelListViewController.h"
#import "CitySearchViewController.h"

#import "HotelLoactionBottom.h"

@interface HotelInquireViewController ()
///返回
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
///消息
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
///地址（定位）
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
///开始时间
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
///开始星期几
@property (weak, nonatomic) IBOutlet UILabel *startWeekLabel;
///总共多少天
@property (weak, nonatomic) IBOutlet UILabel *allDayLabel;
///结束时间
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
///结束星期几
@property (weak, nonatomic) IBOutlet UILabel *endWeekLabel;
///酒店区域
@property (weak, nonatomic) IBOutlet UILabel *hotelArea;
///价格/星级
@property (weak, nonatomic) IBOutlet UILabel *price;
///定位
@property (weak, nonatomic) IBOutlet HotelLoactionBottom *locationBtn;
@end

@implementation HotelInquireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //隐藏导航栏
    objc_setAssociatedObject(self, @selector(fd_prefersNavigationBarHidden), @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 返回
 */
- (IBAction)clickBack:(UIButton *)sender {
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 消息
 */
- (IBAction)clickMessage:(UIButton *)sender {
    NSLog(@"消息");
}

/**
 开始搜索
 */
- (IBAction)search:(UIButton *)sender {
    NSLog(@"搜索");
    HotelListViewController *hotelListVC = [[HotelListViewController alloc] init];
    [self.navigationController pushViewController:hotelListVC animated:YES];
}

/**
 地区选择
 */
- (IBAction)clickAddress:(UIButton *)sender {
    NSLog(@"地区");
    CitySearchViewController * cityVC = [[CitySearchViewController alloc] init];
    
    
    [self presentViewController:cityVC animated:YES completion:nil];
}

/**
 定位
 */
- (IBAction)clickLoaction:(HotelLoactionBottom *)sender {
     NSLog(@"定位");
}
/**
 选择日期
 */
- (IBAction)clickTime:(UIButton *)sender {
     NSLog(@"日期");
}
/**
 区域选择
 */
- (IBAction)clickArea:(UIButton *)sender {
     NSLog(@"区域");
}
/**
 价格选择
 */
- (IBAction)clickPrice:(UIButton *)sender {
     NSLog(@"价格");
}

#pragma -mark -
#pragma -mark - nac
- (BOOL)fd_prefersNavigationBarHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
