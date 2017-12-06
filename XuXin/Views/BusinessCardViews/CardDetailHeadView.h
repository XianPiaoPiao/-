//
//  CardDetailHeadView.h
//  XuXin
//
//  Created by xian on 2017/9/28.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BusinessCardModel;
@interface CardDetailHeadView : UIView

@property (nonatomic, strong) UILabel *firstNameLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *jobLabel;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) BusinessCardModel *model;

@end
