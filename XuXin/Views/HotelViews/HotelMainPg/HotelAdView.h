//
//  HotelAdView.h
//  HotelUIDemo
//
//  Created by xian on 2018/2/1.
//  Copyright © 2018年 xian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotelAdViewDelegate
/**
 顶部广告区域的点击事件
 
 @param buttonName 事件名称
 */
- (void)selectHotelButton:(NSString *)buttonName;

@end

@interface HotelAdView : UIView

@property (nonatomic, strong) UIScrollView *adScrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIButton *msgButton;

@property (nonatomic, strong) EasySearchBar *searchBar;

@property (nonatomic, strong) UIButton *homePageButton;

@property (nonatomic, strong) NSArray *scrollImageArray;

@property (nonatomic, assign) id<HotelAdViewDelegate> delegate;

@end
