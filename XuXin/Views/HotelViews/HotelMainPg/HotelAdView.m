//
//  HotelAdView.m
//  HotelUIDemo
//
//  Created by xian on 2018/2/1.
//  Copyright © 2018年 xian. All rights reserved.
//

#import "HotelAdView.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface HotelAdView ()<UITextFieldDelegate>
@property (nonatomic, assign) NSInteger imagePage;
@end

@implementation HotelAdView {
    NSTimer *_timer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)setScrollImageArray:(NSArray *)scrollImageArray {
    _scrollImageArray = scrollImageArray;
    for (int i = 0; i< _scrollImageArray.count; i++) {
        
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake((i+1)*ScreenW, 0, ScreenW, 200)];

        [imgView setImage:[UIImage imageNamed:_scrollImageArray[i]]];
        
        [_adScrollView addSubview:imgView];
        
    }
    
    UIImageView *lastImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 200)];
    [lastImgView setImage:[UIImage imageNamed:_scrollImageArray[self.scrollImageArray.count-1]]];
    [_adScrollView addSubview:lastImgView];
    
    _adScrollView.pagingEnabled = YES;
    _adScrollView.contentSize = CGSizeMake((self.scrollImageArray.count +1) *ScreenW, 0);
    
    _pageControl.numberOfPages = _scrollImageArray.count;
    [_pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    
    [_pageControl addTarget:self action:@selector(chagePage:) forControlEvents:UIControlEventValueChanged];
    
    //tableView滑动时保持状态
    _adScrollView.contentOffset = CGPointMake(ScreenW * _imagePage, 0);
    _pageControl.currentPage = _imagePage;
    
    //轮播图
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(slider) userInfo:nil repeats:YES];
    //加到runloop里面
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}

- (void)createUI {
    
    [self.adScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(20);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    
    [self.homePageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.top.equalTo(self.mas_top).offset(30);
        make.size.sizeOffset(CGSizeMake(40, 30));
    }];
    
    [self.msgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.top.equalTo(self.mas_top).offset(30);
        make.size.sizeOffset(CGSizeMake(26, 26));
    }];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.homePageButton.mas_right).offset(10);
        make.centerY.equalTo(self.homePageButton.mas_centerY);
        make.height.mas_offset(30);
        make.right.equalTo(self.msgButton.mas_left).offset(-15);
    }];
    
    
    
}

- (UIScrollView *)adScrollView {
    if (!_adScrollView) {
        _adScrollView = [[UIScrollView alloc] init];
        _adScrollView.showsHorizontalScrollIndicator = NO;
        _adScrollView.pagingEnabled = YES;
        [self addSubview:_adScrollView];
    }
    return _adScrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (UIButton *)msgButton {
    if (!_msgButton) {
        _msgButton = [[UIButton alloc] init];
        [_msgButton setImage:[UIImage imageNamed:@"home_page_information_icon"] forState:UIControlStateNormal];
        [_msgButton addTarget:self action:@selector(clickMsgButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_msgButton];
    }
    return _msgButton;
}

- (UIButton *)homePageButton {
    if (!_homePageButton) {
        _homePageButton = [[UIButton alloc] init];
        [_homePageButton setTitle:@"首页" forState:UIControlStateNormal];
        [_homePageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_homePageButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_homePageButton addTarget:self action:@selector(clickHomePageButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_homePageButton];
    }
    return _homePageButton;
}

- (EasySearchBar *)searchBar {
    //搜索框
    if (!_searchBar) {
        _searchBar = [[EasySearchBar alloc] initWithFrame:CGRectMake(102, 25, ScreenW-115, 32)];
        _searchBar.searchField.delegate = self;
        _searchBar.backgroundColor = [UIColor whiteColor];
        [self addSubview:_searchBar];
        _searchBar.layer.cornerRadius = 16.0f;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.easySearchBarPlaceholder = @"输入酒店名称";
    }
    return _searchBar;
}

- (void)clickHomePageButton {
    [self.delegate selectHotelButton:@"homePage"];
}

- (void)clickMsgButton {
    [self.delegate selectHotelButton:@"message"];
}

#pragma mark ---- UITextFieldDelegate方法
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self.delegate selectHotelButton:@"searchBar"];
    [self endEditing:YES];
}

-(void)slider{
    _pageControl.currentPage = _imagePage;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        _adScrollView.contentOffset = CGPointMake((_imagePage+1)*ScreenW, 0);
    }];
    if (_imagePage> self.scrollImageArray.count) {
        
        _adScrollView.contentOffset = CGPointMake(ScreenW, 0);
    }
}

#pragma mrak  ----scrollViewwDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //开起定时器
    if (scrollView == _adScrollView) {
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            
            [_timer setFireDate:[NSDate distantPast]];
            
        });
        
    }
    [self endEditing:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    CGPoint point = scrollView.contentOffset;
    
    NSUInteger currentPage = point.x/_adScrollView.frame.size.width;
    if (_imagePage> self.scrollImageArray.count) {
        
        _adScrollView.contentOffset = CGPointMake(ScreenW, 0);
    }
    
    _pageControl.currentPage = currentPage;
    
    _imagePage = currentPage;
        
   
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _adScrollView) {

        [_timer setFireDate:[NSDate distantFuture]];

    }

}
-(void)chagePage:(UIPageControl *)page{
    
    float x= page.currentPage * _adScrollView.frame.size.width;
    [_adScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
