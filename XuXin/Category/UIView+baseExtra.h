//
//  UIView+baseExtra.h
//  LR_FrameWork
//
//  Created by LiRun on 15/9/21.
//  Copyright © 2015年 李润. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (baseExtra)

/**
 * 添加点击事件
 */
- (void)addTapTarget:(id)target action:(SEL)sel;

/**
 *  删除当前视图的所有子视图
 */
- (void)removeSubviews;

/**
 * 获得文本框
 * @param tag Tag值
 */
- (UITextField *)textfiled4Tag:(int)tag;
- (UIButton *)button4Tag:(int)tag;
- (UILabel *)label4Tag:(int)tag;
- (UIImageView *)imageView4Tag:(int)tag;

#pragma mark - 计算坐标
#pragma  mark -
/**
 * 获得当前视图的结束点坐标 值为 frame 的 y + height
 */
@property(nonatomic,assign) CGFloat endY;


/**
 * 获得当前视图的结束点坐标 值为 frame 的 x + width
 */
@property(nonatomic,assign) CGFloat endX;


/**
 * 获得当前视图的X坐标体系
 */
@property(nonatomic,assign) CGFloat x;

/**
 * 获得当前视图的Y坐标体系
 */
@property(nonatomic,assign) CGFloat y;


/**
 * 获得当前视图的高度
 */
@property(nonatomic,assign) CGFloat height;


/**
 * 获得当前视图的宽度
 */
@property(nonatomic,assign) CGFloat width;


/**
 * 获得View的大小
 */
@property(nonatomic,assign) CGSize size;
/** 获取view的xy */
@property(nonatomic,assign) CGPoint XY;

@property(nonatomic,assign) CGFloat centerX;

@property(nonatomic,assign) CGFloat centerY;

#pragma  mark - 其他方法
/**
 * 将UIView转成UIImage
 */
-(UIImage *)yjy_viewToImage;

#pragma makr 圆角
-(void)setRoundType;
-(void)setRoundTypeByAngle:(float)angle;
-(void)setBorderColor:(UIColor*)color borderWidth:(CGFloat)width;
-(void)cornerRadius;
-(void)cornerRadiusWithColor:(UIColor *)color;
-(void)cornerRadius:(CGFloat )cornerRadius AndBorderWidth:(CGFloat )borderWidth AndBorderColor:(UIColor *)borderColor;
@end


@interface UIView (registerCell)
-(void )registerHeaderWithHeaderViewNibNames:(NSArray *)headerViewNames;
-(void )registerHeaderWithHeaderViewClassNames:(NSArray *)headerViewNames;

-(void )registerFooterWithFooterViewNibNames:(NSArray *)footerViewNames;
-(void )registerFooterWithFooterViewClassNames:(NSArray *)footerViewNames;

-(void )registerCellWithCellNibNames:(NSArray *)cellNibNames;
-(void )registerCellWithCellClassNames:(NSArray *)classNames;
@end
