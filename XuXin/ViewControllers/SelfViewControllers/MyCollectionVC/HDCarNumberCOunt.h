//
//  HDCarNumberCOunt.h
//  XuXin
//
//  Created by xuxin on 16/9/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^JSNumberChangeBlock)(NSInteger count);

@interface HDCarNumberCOunt : UIView
/**
 *  总数
 */
@property (nonatomic, assign) NSInteger           totalNum;
/**
 *  当前显示价格
 */
@property (nonatomic, assign) NSInteger           currentCountNumber;
/**
 *  数量改变回调
 */
@property (nonatomic, copy  ) JSNumberChangeBlock NumberChangeBlock;
@end
