//
//  HDFooterView.h
//  XuXin
//
//  Created by xuxin on 16/9/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDFooterView : UITableViewHeaderFooterView
@property (nonatomic, strong) NSMutableArray *shopGoodsArray;

+ (CGFloat)getCartFooterHeight;
@end
