//
//  FriendsCardTableViewCell.h
//  XuXin
//
//  Created by xian on 2017/9/23.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BusinessCardModel;

@interface FriendsCardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic, copy) BusinessCardModel *model;

@end
