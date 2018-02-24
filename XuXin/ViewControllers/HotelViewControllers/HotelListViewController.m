//
//  HotelListViewController.m
//  TableDemo
//
//  Created by 沈鑫 on 2018/2/2.
//  Copyright © 2018年 沈鑫. All rights reserved.
//

#import "HotelListViewController.h"
#import "HotelDetailViewController.h"

//view
#import "HotelNavView.h"
#import "HotelToolView.h"
#import "HotelHeaderSectionView.h"
//cell
#import "HotelListCell.h"
//category
#import "UIView+baseExtra.h"

@interface HotelListViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,HotelNavViewDelegate>

/**
 酒店列表
 */
@property (weak, nonatomic) IBOutlet UITableView *hotelList;

/**
 列表top约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

/**
 自定义导航栏
 */
@property (nonatomic,strong) HotelNavView *navView;

/**
 筛选
 */
@property (nonatomic,strong) HotelToolView *toolView;
@end

@implementation HotelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
    
}

#pragma -mark initUI
-(void)initUI{
    //隐藏导航栏
    objc_setAssociatedObject(self, @selector(fd_prefersNavigationBarHidden), @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //自定义导航栏
    self.navView = [[HotelNavView alloc]initWithFrame:CGRectMake(0, 0, ScreenW , KNAV_TOOL_HEIGHT)];
    self.navView.delegate = self;
   [self.view addSubview:self.navView];
    
    self.toolView = [[[NSBundle mainBundle] loadNibNamed:@"HotelToolView" owner:nil options:nil] firstObject];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          self.hotelList.tableHeaderView = self.toolView;
    });
    
    if (@available(iOS 11.0,*)) {
        self.hotelList.estimatedRowHeight =0;
        self.hotelList.estimatedSectionHeaderHeight =0;
        self.hotelList.estimatedSectionFooterHeight =0;
        self.hotelList.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

}

#pragma -mark initData
-(void)initData{
    
}

#pragma -mark HotelNavViewDelegate
- (void)clickNavViewButton:(NSString *)string {
    if ([string isEqualToString:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([string isEqualToString:@"calendar"]) {
        NSLog(@"日历");
    } else if ([string isEqualToString:@"search"]) {
        NSLog(@"搜索");
    } else if ([string isEqualToString:@"location"]) {
        NSLog(@"定位");
    } else if ([string isEqualToString:@"message"]) {
        NSLog(@"消息");
    }
}

#pragma -mark UITableViewDataSource,UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 99, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 99, 0, 0)];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotelListCell *cell = [HotelListCell initWithTbView:tableView];
    [cell showData:nil];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [HotelListCell getHeight];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HotelHeaderSectionView *sectionView = [[HotelHeaderSectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 45)];
    return sectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath.section:%ld,indexPath.row:%ld",indexPath.section,indexPath.row);
    HotelDetailViewController *hotelDetailVC = [[HotelDetailViewController alloc] init];
    [self.navigationController pushViewController:hotelDetailVC animated:YES];
}

#pragma -mark -
#pragma -mark - nac
- (BOOL)fd_prefersNavigationBarHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

#pragma -mark UIScrollViewDelegate
#pragma -mark 视图滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.navView.height = 0;
            self.navView.alpha = 0;
            self.toolView.height = 0;
        } completion:^(BOOL finished) {
            self.topConstraint.constant = 20;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.topConstraint.constant = 64;
            self.navView.height = 64;
            self.toolView.height = 45;
        } completion:^(BOOL finished) {
            self.navView.alpha = 1;
        }];
    }
}

#pragma -mark lazy


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
