//
//  HDHeaderView.h
//  XuXin
//
//  Created by xuxin on 16/9/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) UIButton *selectStoreGoodsButton;
@property (nonatomic, strong) UIButton * storeNameButton;
;

+ (CGFloat)getCartHeaderHeight;
@end
