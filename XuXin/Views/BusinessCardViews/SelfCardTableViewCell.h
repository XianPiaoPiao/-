//
//  SelfCardTableViewCell.h
//  XuXin
//
//  Created by xian on 2017/9/27.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BusinessCardModel;

@interface SelfCardTableViewCell : UITableViewCell
///头像
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *wordL;
///昵称
@property (nonatomic, strong) UILabel *nameLabel;
///工作
@property (nonatomic, strong) UILabel *jobLabel;
///二维码
@property (nonatomic, strong) UIButton *codeButton;
///发名片
@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) UILabel *createLbl;

@property (nonatomic, strong) UIImageView *nextImgView;

+ (CGFloat) heightForSelfCardCell;

@property (nonatomic, copy) BusinessCardModel *model;

@property (nonatomic, assign) BOOL isExit;

@end
