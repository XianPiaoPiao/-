//
//  HotelMainViewController.m
//  HotelUIDemo
//
//  Created by xian on 2018/1/31.
//  Copyright © 2018年 xian. All rights reserved.
//

#import "HotelMainViewController.h"
#import "HotelDetailViewController.h"
#import "HotelInquireViewController.h"
//view
#import "HotelAdView.h"
//cell
#import "HotelMainCell.h"
#import "hotelRecommendCell.h"
//category
#import "UIButton+WebCache.h"
//model
#import "AdervertModel.h"


@interface HotelMainViewController ()<UITableViewDelegate,UITableViewDataSource,HotelAdViewDelegate>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) NSDictionary *dataSource;

@property (nonatomic, strong) UIScrollView *imageScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic ,assign)NSInteger imagePage;

@end

@implementation HotelMainViewController {
    NSTimer *_timer;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[@[@"1",@"2",@"3"],
                       @[@"1"],
                       @[@"1",@"2",@"3"],
                       @[@"1"],
                       @[@"1",@"2",@"3",@"4",@"5",@"6"]];
    NSArray *imgArray = @[@"home_page_banner",@"home_page_picture",@"home_page_banner",@"home_page_picture",@"home_page_banner"];
    _dataSource = @{@"array":array,
                    @"imgArray":imgArray
                    };
    [self createTableView];
    if (_dataSource) {
        [self.mainTableView reloadData];
    }
//    [self requestData];
    
    //轮播图
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(slider) userInfo:nil repeats:YES];
    //加到runloop里面
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)createTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, ScreenW, screenH) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        [self.view addSubview:_mainTableView];
    }
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"HotelMainCell" bundle:nil] forCellReuseIdentifier:@"HotelMainCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"hotelRecommendCell" bundle:nil] forCellReuseIdentifier:@"hotelRecommendCell"];
}

- (void)requestData {
    
    __weak typeof(self)weakself = self;
//    NSMutableDictionary * param = [NSMutableDictionary dictionary];
//    param[@"value"] = @"1";
    NSString *stringUrl = @"http://192.168.1.20:8080/app/hotel/home_page.htm";
    [weakself POST:stringUrl parameters:nil success:^(id responseObject) {
        
        
        if ([responseObject[@"isSucc"] integerValue] == 1) {
            NSDictionary *dic = responseObject[@"result"];
            NSLog(@"%@",dic);
        }
        
        
    } failure:^(NSError *error) {
        
        
    }];
    
    if (_dataSource) {
        [self.mainTableView reloadData];
    }
}

#pragma mark 图片滚动
-(void)slider{
    _pageControl.currentPage = _imagePage;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        _imageScrollView.contentOffset = CGPointMake((_imagePage+1)*ScreenW, 0);
    }];
    if (_imagePage> 3) {
        
        _imageScrollView.contentOffset = CGPointMake(0, 0);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _imageScrollView) {
        
        CGPoint point = scrollView.contentOffset;
        
        
        NSUInteger currentPage = point.x/_imageScrollView.frame.size.width;
        if (_imagePage> 3) {
            
            _imageScrollView.contentOffset = CGPointMake(0, 0);
        }
        
        _pageControl.currentPage = currentPage;
        
        _imagePage = currentPage;
        
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _imageScrollView) {
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

-(void)chagePage:(UIPageControl *)page{
    
    float x= page.currentPage * _imageScrollView.frame.size.width;
    [_imageScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    
}
#pragma mark ---UITableViewDelegate,UITableViewDataSource---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 200;
    } else if (indexPath.section == 1){
        return [HotelMainCell getHeight:self.dataSource[@"array"][indexPath.section-1]];
    } else if (indexPath.section == 2){
        return 155;
    } else if (indexPath.section == 3){
        return [HotelMainCell getHeight:self.dataSource[@"array"][indexPath.section-1]];
    } else if (indexPath.section == 4){
        return 90;
    } else{
        return [HotelMainCell getHeight:self.dataSource[@"array"][indexPath.section-1]];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:BackColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell;
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        }
        HotelAdView *adView = [[HotelAdView alloc] initWithFrame:cell.bounds];
        adView.delegate = self;
        NSArray *array = self.dataSource[@"imgArray"];
        adView.scrollImageArray = array;
        [cell.contentView addSubview:adView];
        return cell;
    } else if (indexPath.section == 1) {
        HotelMainCell *cell = [HotelMainCell initWithTableView:tableView];
        [cell showData:self.dataSource[@"array"][indexPath.section-1]];
        return cell;
    } else if (indexPath.section == 2) {
        hotelRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotelRecommendCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"hotelRecommendCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
//        [cell showData:self.dataSource[indexPath.section-1]];
        return cell;
    } else if (indexPath.section == 3) {
        HotelMainCell *cell = [HotelMainCell initWithTableView:tableView];
        [cell showData:self.dataSource[@"array"][indexPath.section-1]];
        return cell;
    } else if (indexPath.section == 4) {
        CGFloat imageH = 90 * ScreenScale;
        
        UITableViewCell * cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenW, imageH)];
        _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, imageH)];
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        _imageScrollView.delegate = self;
        
        for (int i = 0; i< 3; i++) {
            
            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*ScreenW, 0, ScreenW, 90)];
            
            [imgView setImage:[UIImage imageNamed:@"home_carousel"]];
            
            [_imageScrollView addSubview:imgView];
            
        }
        
        _imageScrollView.pagingEnabled = YES;
        _imageScrollView.contentSize = CGSizeMake(3 *ScreenW, 0);
        
        //创建pagecontrol
        _pageControl = [[UIPageControl alloc] init];
        [cell addSubview:_imageScrollView];
        [cell addSubview:_pageControl];
        //创建约束
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageScrollView.mas_left);
            make.right.equalTo(_imageScrollView.mas_right);
            make.bottom.equalTo(_imageScrollView.mas_bottom);
            make.height.equalTo(@20);
        }];
        _pageControl.numberOfPages = 3;
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
        
        [_pageControl addTarget:self action:@selector(chagePage:) forControlEvents:UIControlEventValueChanged];
        
        //tableView滑动时保持状态
        _imageScrollView.contentOffset = CGPointMake(ScreenW * _imagePage, 0);
        _pageControl.currentPage = _imagePage;
        
        
        return cell;
    } else if (indexPath.section == 5) {
        HotelMainCell *cell = [HotelMainCell initWithTableView:tableView];
        [cell showData:self.dataSource[@"array"][indexPath.section-1]];
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath.section=%ld,indexPath.row=%ld",indexPath.section,indexPath.row);
}

#pragma mark ---顶部广告区域的点击事件---
- (void)selectHotelButton:(NSString *)buttonName {
    if ([buttonName isEqualToString:@"homePage"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([buttonName isEqualToString:@"message"]) {
        NSLog(@"message");
    } else if ([buttonName isEqualToString:@"searchBar"]) {
        NSLog(@"searchBar");
//        HotelDetailViewController *detailVC = [[HotelDetailViewController alloc] init];
//        [self.navigationController pushViewController:detailVC animated:YES];
        HotelInquireViewController *inquireVC = [[HotelInquireViewController alloc] init];
        [self.navigationController pushViewController:inquireVC animated:YES];
    }
}



-(NSDictionary *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSDictionary dictionary];
    }
    return _dataSource;
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
