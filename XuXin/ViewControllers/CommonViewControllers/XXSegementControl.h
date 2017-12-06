//
//  XXSegementControl.h
//  定制segmentControl
//
//  Created by xuxin on 16/4/12.
//  Copyright © 2016年 xuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXSegementControl : UIView
@property(nonatomic, strong) NSArray * items;
@property(nonatomic, assign) NSUInteger  selectedSegmentIndex;
@property (nonatomic,strong) UIView * sliderView;
-(instancetype)initWithItems:(NSArray *)items;
-(void)addTarget:(id)target action:(SEL)action;
@end
