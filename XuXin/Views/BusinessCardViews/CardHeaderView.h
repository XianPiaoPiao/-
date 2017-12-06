//
//  CardHeaderView.h
//  XuXin
//
//  Created by xian on 2017/9/23.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, assign) BOOL type;//yes:自己
@end
