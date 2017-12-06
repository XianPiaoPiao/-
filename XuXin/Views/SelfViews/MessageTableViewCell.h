//
//  MessageTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/8/26.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageListModel.h"

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (nonatomic ,strong)MessageListModel * model;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
-(CGFloat)getPointCellHeight:(MessageListModel *)pointModel;
@end
