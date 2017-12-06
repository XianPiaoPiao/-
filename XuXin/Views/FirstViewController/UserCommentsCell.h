//
//  UserCommentsCell.h
//  XuXin
//
//  Created by xuxin on 17/3/8.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarsView.h"
#import "UserCommentsModel.h"
@interface UserCommentsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userHeadereImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet StarsView *startsView;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic ,strong)UserCommentsModel * commentsModel;

@property (nonatomic ,strong)UserCommentsModel * goodsModel;

-(CGFloat)getPointCellHeight:(UserCommentsModel *)commentModel;
@end
